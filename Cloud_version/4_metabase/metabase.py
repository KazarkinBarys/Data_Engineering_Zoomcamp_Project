from metabase_api import Metabase_API
import metabase_set
from prefect import flow, task
import subprocess

@flow(name="metabase_flow", log_prints=True, description = 'Input metabase login and password\n \
      example:["admin@admin.com", "root123root"] \n\
      Optionally input also ip of metabase container \n\
      example:["admin@admin.com", "root123root", "http://172.21.0.2:3000/"]')
def metabase(metabase_credentials):
    #connection 
    mblogin = metabase_credentials[0]
    mbpass = metabase_credentials[1]
    if len(metabase_credentials) == 3: 
        mbip = metabase_credentials[2]
        try:
            mb = Metabase_API(mbip, mblogin, mbpass)
            print("connection ok")
        except:
            print(mb)
            print("connection failed")
            return() 
    elif len(metabase_credentials) == 2:

        output = subprocess.check_output("ip r", shell=True).decode()
        ip_cont = output.split()[2]
        ip_cont_f = ".".join(ip_cont.split('.')[:3])

        for i in range(2,6):
            try: 
                mbip = f'http://{ip_cont_f}.{i}:3000/'
                mb = Metabase_API(mbip, mblogin, mbpass)
                print("connection ok")
                break
            except:
                pass
        else:
            print(mb)
            print("connection failed")
            return()
    
    #collection creation
    try:
        colid = mb.get_item_id('collection', "MVC_collection")
        print("collection 'MVC_collection' exists")
    except:
        mb.create_collection("MVC_collection", parent_collection_name='Root', return_results=False)
        print("collection 'MVC_collection' created")
        colid = mb.get_item_id('collection', "MVC_collection")

    #checking database
    try:
        dbid = mb.get_item_id('database', "MVC_db")
        print("database ok")
    except:
        print("MVC_db not found:connect or rename database")
        return()

    #cards creation
    crd_names = metabase_set.crd_names
    for i in crd_names:
        crd = i
        crd['dataset_query']['database'] = dbid
        crdnm = crd['name']
        try: 
            crdid = mb.get_item_id('card', crdnm, collection_name = "MVC_collection", collection_id=colid)
        except: 
            crdid = -1
        if crdid == -1:
            mb.create_card(custom_json = crd, collection_id = colid)
            print(f"card {crdnm} created")
        else:
            mb.delete_item('card', item_name = crdnm, collection_name = "MVC_collection", collection_id=colid, verbose=False)
            mb.create_card(custom_json = crd, collection_id = colid)
            print(f"card {crdnm} overwrited")

    #dashboard creation
    dashboard_data = {
    'name': 'MVC_dashboard',
    'collection_id': colid,
    'archived': False,
    'ordered_cards': []
    }
    try: 
        dashid = mb.get_item_id('dashboard', 'MVC_dashboard', collection_name = "MVC_collection", collection_id=colid)
    except: 
        dashid = -1
    if dashid == -1:
        mb.post('/api/dashboard/', json=dashboard_data)
        print(f"MVC_dashboard created")
    else:
        mb.delete(f'/api/dashboard/{dashid}')
        mb.post('/api/dashboard/', json=dashboard_data)
        print(f"MVC_dashboard recreated")
    dashid = mb.get_item_id('dashboard', 'MVC_dashboard', collection_name = "MVC_collection", collection_id=colid)

    #filling dashboard with cards
    params = metabase_set.params
    for crd in crd_names:
        crdnm = crd['name']
        crd_params = params[crdnm]
        crd_id = mb.get_item_id('card', crdnm, collection_name = "MVC_collection", collection_id=colid)
        crd_params['cardId'] = crd_id
        mb.post(f'/api/dashboard/{dashid}/cards', json=crd_params)
    print('MVC_dashboard filled and ready for work')




if __name__ == '__main__':

    metabase_credentials = ["admin@admin.com", "root123root"]

    metabase(metabase_credentials)