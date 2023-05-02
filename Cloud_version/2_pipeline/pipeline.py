import pyspark
from pyspark.sql import SparkSession
from pyspark.sql import types
from pyspark.sql import functions as F
from pyspark.sql.functions import year, month, dayofmonth
from pyspark.sql.types import StringType, DateType, FloatType


import os
import time
import hcl2

from prefect_dbt.cli.commands import DbtCoreOperation
from prefect import flow, task
from prefect_aws import AwsCredentials
from pydantic import SecretStr
import boto3

import pipeline_set


@task(log_prints=True, tags=["download"])
def download_data(data_type):
    os.chdir("/Cloud_version/2_pipeline")

    if data_type == "check":
        return("check", data_type)
    
    elif data_type == "upload_to_s3":
        return("upload_to_s3", data_type)
    
    elif data_type[:-2] == "redshift_tables":
        data_type = data_type[-1]
        return("redshift_tables", data_type)
    
    elif data_type[:3] == "dbt":
        return("dbt", data_type)
    
    elif data_type[:1] in ["C","V","P"] and data_type[1:] == " reload":
        data_type = data_type[:1]
        url = getattr(pipeline_set,f"url_{data_type}")
        csv_name = f"MVC_{data_type}.csv"
        os.system(f"wget {url} -O {csv_name}")
        return(csv_name, data_type)
    
    elif data_type in ["C","V","P"]:
        url = getattr(pipeline_set,f"url_{data_type}")
        csv_name = f"MVC_{data_type}.csv"
        if os.path.isfile(csv_name) is not True:
            os.system(f"wget {url} -O {csv_name}")
            return(csv_name, data_type)
        else:
            return(csv_name, data_type)
        
    else:
        return("err")

@task(log_prints=True, tags=["read_and_transform"])
def read_and_transform(csv_name,data_type):
    spark = SparkSession.builder \
    .master("local[*]") \
    .appName('test') \
    .getOrCreate()

    df = spark.read \
    .option("header", "true") \
    .csv(csv_name)

    df = df.select(getattr(pipeline_set,f'sel_{data_type}'))

    sel_temp = getattr(pipeline_set,f'sel_rename_{data_type}')
    for key, value in sel_temp.items():
        df = df.withColumnRenamed(key, value)

    
    df = df.withColumn("crash_date", F.to_date(df.crash_date,'MM/dd/yyyy'))

    df = df.withColumn("crash_time", F.to_timestamp(F.concat_ws(" ",df.crash_date,df.crash_time)))

    
    sel_temp = getattr(pipeline_set,f'sel_types_{data_type}')
    for key, value in sel_temp.items():
        cl = getattr(df,key)
        df = df.withColumn(key,cl.cast(value))
    print('preparation completed')
    return(df)
    
@task(log_prints=True, tags=["save_parquet"])
def save_parquet(years,df,data_type):

    for i in years:
        dftemp = df.filter(year(df.crash_date) == i)
        dftemp.repartition(1).write.mode("overwrite").parquet(f"/Cloud_version/2_pipeline/parquets/MVC_{data_type}_{i}.parquet")
        print(f'loaded {dftemp.count()} rows in MVC_{data_type}_{i} parquet file')

@task(log_prints=True, tags=["upload_parquets_to_s3"])
def upload_parquets_to_s3(bucket, inputDir, s3Path, data_type):
        
    aws_credentials_block = AwsCredentials.load("awscre")
    s3C = boto3.client('s3', aws_access_key_id=aws_credentials_block.aws_access_key_id, aws_secret_access_key=aws_credentials_block.aws_secret_access_key.get_secret_value())
        
        
    print("Uploading results to s3 initiated...")
    print("Local Source:",inputDir)
    

    print("Dest  S3path:",s3Path)

    try:
        for path, subdirs, files in os.walk(inputDir):
            for file in files:
                dest_path = path.replace(inputDir,"")
                if data_type != dest_path[5]:
                    break
                __s3file = os.path.normpath(s3Path + '/' + dest_path )
                #+ '/' + file
                if file[:5] == 'part-':
                    __local_file = os.path.join(path, file)
                    s3C.upload_file(__local_file, bucket,__s3file)  
                    print(f"{dest_path.replace('/','')} uploaded")

    except Exception as e:
        print(" ... Failed!! Quitting Upload!!")
        print(e)
        raise e

def redshift_create_tables_and_insert_data_from_s3 (years, data_type, bucket, s3Path, db_n, schem, work_gr_n):

    aws_credentials_block = AwsCredentials.load("awscre")
    redshiftDataClient = boto3.client('redshift-data', aws_access_key_id=aws_credentials_block.aws_access_key_id, 
                                                       aws_secret_access_key=aws_credentials_block.aws_secret_access_key.get_secret_value(),
                                                       region_name='us-east-1')

    for year in years:
        drop_table = redshiftDataClient.execute_statement(
                Database=db_n,
                WorkgroupName = work_gr_n,
                Sql = f'DROP TABLE IF EXISTS {schem}."MVC_{data_type}_{year}"'
            ) 
        print(f'Deleting table (if exists) MVC_{data_type}_{year}')
        for i in range(15):
            drop_table_status = redshiftDataClient.describe_statement(
            Id=drop_table['Id'])
            
            if drop_table_status['Status'] == 'FINISHED' :
                
                break
            elif drop_table_status['Status'] == 'FAILED' :
                print('operation failed')
                print (drop_table_status)
                break
            else:
                time.sleep(2)
        else:
            return('connection time out')
        
        create_table  = redshiftDataClient.execute_statement(
                Database=db_n,
                WorkgroupName = work_gr_n,
                Sql = f'''CREATE TABLE {schem}."MVC_{data_type}_{year}" {getattr(pipeline_set,f"table_schem_{data_type}")}'''
            ) 
        print(f'Creating table MVC_{data_type}_{year}')
        for i in range(25):
            create_table_status = redshiftDataClient.describe_statement(
            Id=create_table ['Id'])
            
            if create_table_status['Status'] == 'FINISHED' :
                
                break
            elif create_table_status['Status'] == 'FAILED' :
                print('operation failed')
                print (create_table_status)
                break
            else:
                time.sleep(2)
        else:
            return('connection time out')


        insert_data_in_table = redshiftDataClient.execute_statement(
                Database=db_n,
                WorkgroupName = work_gr_n,
                Sql = f'''COPY {schem}."MVC_{data_type}_{year}"
                        FROM 's3://{bucket}/{s3Path[:-1]}/MVC_{data_type}_{year}.parquet'
                        credentials 'aws_access_key_id={aws_credentials_block.aws_access_key_id};aws_secret_access_key={aws_credentials_block.aws_secret_access_key.get_secret_value()}'
                        FORMAT AS PARQUET'''
                                    ) 
        print(f'Insert data from s3 to table MVC_{data_type}_{year}')
        for i in range(35):
            insert_data_in_table_status = redshiftDataClient.describe_statement(
            Id=insert_data_in_table ['Id'])
            
            if insert_data_in_table_status['Status'] == 'FINISHED' :
                print('success')
                break
            elif insert_data_in_table_status['Status'] == 'FAILED' :
                print('operation failed')
                print (insert_data_in_table_status)
                break
            else:
                time.sleep(2)
        else:
            return('connection time out')
        


def check_downloaded_data(db_n,schem, work_gr_n):
    aws_credentials_block = AwsCredentials.load("awscre")
    redshiftDataClient = boto3.client('redshift-data', aws_access_key_id=aws_credentials_block.aws_access_key_id, 
                                                       aws_secret_access_key=aws_credentials_block.aws_secret_access_key.get_secret_value(),
                                                       region_name='us-east-1')

    res = [['year', 'Crashes','Vehicles','Person']]
    for i in range(2012,2024):
        print(f"{i} spreadsheets check")
        temp = []
        temp.append(i)

        dc =[]
        for dtp in ["C", "V", "P"]:
            data_checking  = redshiftDataClient.execute_statement(
                    Database=db_n,
                    WorkgroupName = work_gr_n,
                    Sql=(f'SELECT COUNT(*) FROM {schem}."MVC_{dtp}_{i}"'
                        ))
            dc.append(data_checking['Id'])

        
        for hh in range(3):
            for y in range(15):
                data_checking_status = redshiftDataClient.describe_statement(
                Id = dc[hh])
                
                if data_checking_status['Status'] == 'FINISHED' or data_checking_status['Status'] == 'FAILED':
                    break
                else:
                    time.sleep(2)
            else:
                return('connection time out')

        for d in range(3):
            try:
                data_checking_result = redshiftDataClient.get_statement_result(
                    Id = dc[d]) 
            except:
                data_checking_result = 0
            try:
                t = int(data_checking_result['Records'][0][0]['longValue'])
            except:
                t = 0
            temp.append(t)
        res.append(temp)
        
    C,V,P =0,0,0
    st = '   Downloaded data report:' + '\n'  + '\n'
    for i in range(13):
        for j in range(4):
            if i == 0 or j == 0:
                h = res[i][j]
            else: 
                h = "{:,}".format(res[i][j])
            st += str(h).rjust(11)
        st += '\n'
        if i > 0:
            C += int(res[i][1])
            V += int(res[i][2])
            P += int(res[i][3])
    st = st + '\n' + 'total'.rjust(11) + str("{:,}".format(C)).rjust(11) + str("{:,}".format(V)).rjust(11) + str("{:,}".format(P)).rjust(11)
    print(st)


def dbt_trigger(dbt_com, db_n, work_gr_n):
    aws_credentials_block = AwsCredentials.load("awscre")
    redshiftDataClient = boto3.client('redshift-data', aws_access_key_id=aws_credentials_block.aws_access_key_id, 
                                                       aws_secret_access_key=aws_credentials_block.aws_secret_access_key.get_secret_value(),
                                                       region_name='us-east-1')

    if dbt_com == "dbt" or dbt_com == "dbt_run":
        drop_schema = redshiftDataClient.execute_statement(
                Database=db_n,
                WorkgroupName = work_gr_n,
                Sql = f'DROP SCHEMA IF EXISTS "MVC_summarize" CASCADE'
            ) 
        print(f'Deleting schema (if exists) MVC_summarize')
        for i in range(15):
            drop_schema_status = redshiftDataClient.describe_statement(
            Id=drop_schema['Id'])
            
            if drop_schema_status['Status'] == 'FINISHED' :
                print('success')
                break
            elif drop_schema_status['Status'] == 'FAILED' :
                print('operation failed')
                print (drop_schema_status)
                break
            else:
                time.sleep(2)
        else:
            return('connection time out')
        
        dbt_run_com("dbt debug")
        dbt_run_com("dbt run --exclude mvc_dataset_overview mvc_sum_all mvc_crashes_per_month")
        dbt_run_com("dbt run --select mvc_dataset_overview mvc_sum_all mvc_crashes_per_month")
    else:
        dbt_run_com(dbt_com)

def dbt_run_com(dbt_com):
    result = DbtCoreOperation(
        commands=[dbt_com],
        project_dir="/Cloud_version/3_dbt/zoomcamp",
        profiles_dir="/Cloud_version/3_dbt"
    ).run()
    return result



    







@flow(name="MVC_main", log_prints=True, description = "Select dataset for processing: \n \
'C' for Motor Vehicle Collisions - Crashes \n\
'V' for Motor Vehicle Collisions - Vehicles \n\
'P' for Motor Vehicle Collisions - Person \n\
Select years for partitioning and upload into database(separate table for each selected year). \n\
Years presented in the dataset: \n\
[2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023] \n\
Or select 'check' for checking downloaded data into database. \n\
Or '[data_type] reload' for reloading dataset \n\
Or 'upload_to_s3' for upload all parquet files to s3 \n\
Or 'redshift_tables [data_type]' for upload selected data from s3 paruet files to redshift  \n\
Or 'dbt' for run dbt models")
def MVC_main(data_type, years):

    csv_name, data_type = download_data(data_type)

    
    inputDir = '/Cloud_version/2_pipeline/parquets'
    s3Path = 'zoomcamp/'
    schem = '"public"'

    path_to_1_terraform_variables_tf = '/Cloud_version/1_terraform/variables.tf'
    with open(path_to_1_terraform_variables_tf, 'r') as f:
        tfvars = hcl2.load(f)

    variables = tfvars['variable']
    for y in variables:
        for key, value in y.items() :
            if key == "db_name":
                db_n = value['default']
            elif key == "workgroup_name":
                work_gr_n = value['default']
            elif key == "s3_bucket_name":
                bucket = value['default']

    if  csv_name == "err":
        return(print("data_type error, please choose 'C','V','P' for data_type, 'check' for checking downloaded data into database, '[data_type] reload' for reloading dataset"))
    
    elif csv_name == "upload_to_s3":
        tr = ["C","V","P"]
        for i in tr:
            data_type = i
            upload_parquets_to_s3(bucket, inputDir, s3Path, data_type)
    
    elif csv_name == "redshift_tables":
        redshift_create_tables_and_insert_data_from_s3 (years, data_type, bucket, s3Path, db_n, schem, work_gr_n)
    
    elif csv_name == "check":
        check_downloaded_data(db_n, schem, work_gr_n)
    
    elif csv_name == "dbt":
        dbt_com = data_type
        dbt_trigger(dbt_com, db_n, work_gr_n)

    else: 
        df = read_and_transform(csv_name,data_type)
        save_parquet(years,df,data_type)
        
        upload_parquets_to_s3(bucket, inputDir, s3Path, data_type)
        redshift_create_tables_and_insert_data_from_s3 (years, data_type, bucket, s3Path, db_n, schem, work_gr_n)
        


if __name__ == '__main__':

    data_type = "C" # "C" for crashes, "V" for vehicles, "P" for person

    #years = [i for i in range(2012,2024)]
    #years = [2012,2013,2014,2015,2016,2017,2018,2019, 2020, 2021,2022,2023]
    years = [2016,2017,2020]


    MVC_main(data_type, years)