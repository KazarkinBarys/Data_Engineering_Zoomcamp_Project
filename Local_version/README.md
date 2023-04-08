# Tutorial
## Project architecture

1. Creating PostgreSQL database and environment (docker)
2. Download datasets from source (prefect + python)
3. Transformation and loading data into the database (prefect + python)
4. Transformation, modeling and generalization of data into a database (dbt)
5. Visualization of transformed and generalized data (metabase)

![alt text](https://github.com/kostoccka/Data-Engeneering-Zoomcamp-Project/blob/main/Local/images/local-batch-processing.png)

## Step 0 - preparation
Need to be installed:
  * WSL or native Linux
  * Docker and Docker-compose
  * python 3*
  * dbt-postgres
  * pip libraries from requirements.txt
  
```
pip install -r requirements.txt
pip install dbt-postgres
```

## Step 1 - Creating PostgreSQL database and environment (docker)
Declare your mount volume in docker-compose.yaml file. 

Run docker-compose from "1.docker" folder:

```
docker-compose up
```
This will create PostgreSQL database, pgadmin API and metabase containers with defined in docker-compose.yaml logins and passwords.
For setup connection to PostgreSQL database via pgadmin API open http://localhost:8080 in browser, input login and password from docker-compose.yaml and setup server connection:

![alt text](https://github.com/kostoccka/Data-Engineering-Zoomcamp-Project/blob/main/Local/images/pgadmin_1.png)
![alt text](https://github.com/kostoccka/Data-Engineering-Zoomcamp-Project/blob/main/Local/images/pgadmin_2.png)
![alt text](https://github.com/kostoccka/Data-Engineering-Zoomcamp-Project/blob/main/Local/images/pgadmin_3.png)


## Step 2 and 3 - Download datasets from source, transform it and upload into the database (prefect + python)
Run prefect API from "2.pipeline" folder:
```
prefect orion start
```
Go to prefect API http://127.0.0.1:4200/blocks and define SQLAlchemy Connector block like this:

![alt text](https://github.com/kostoccka/Data-Engineering-Zoomcamp-Project/blob/main/Local/images/sqlalch-conn-prefect.png)

```
"name": "psgres-connector", "driver": "postgresql+psycopg2", "database": "MVC_db",

"username": "root", "password": "root", "host": "localhost", "port": "5432"
```
Create prefect deployment file:
```
prefect deployment build ./pipeline.py:MVC_main -n MVC_flow
```
Make sure that "working_dir:" for download files in MVC_main-deployment.yaml file is not empty.

Apply new deployment:
```
prefect deployment apply MVC_main-deployment.yaml
```
Go to http://127.0.0.1:4200/deployments click on custom run and define parameters for downloading and processing data:

![alt text](https://github.com/kostoccka/Data-Engineering-Zoomcamp-Project/blob/main/Local/images/prefect_custom_run.png)

Select dataset for download:
  * "C" for Motor Vehicle Collisions - Crashes
  * "V" for Motor Vehicle Collisions - Vehicles
  * "P" for Motor Vehicle Collisions - Person 
  
Select years for partitioning and upload into database(separate table for each selected year). Years presented in the dataset:
```
[2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023]
```
![alt text](https://github.com/kostoccka/Data-Engineering-Zoomcamp-Project/blob/main/Local/images/prefect_run.png)

Start prefect queue with name "default":
```
prefect agent start  --work-queue "default"
```

Go to http://127.0.0.1:4200/flow-runs and check logs of started flow. If everything is done correctly, information about the processed data should appear in the logs:

![alt text](https://github.com/kostoccka/Data-Engineering-Zoomcamp-Project/blob/main/Local/images/prefect_logs.png)

After complete dataprocessing for all 3 datasets("C", "V" and "P"), make sure via pgadmin, that all needed data was ingested in database(tables must be in "public" schema):

![alt text](https://github.com/kostoccka/Data-Engineering-Zoomcamp-Project/blob/main/Local/images/pgadmin_test.png)
