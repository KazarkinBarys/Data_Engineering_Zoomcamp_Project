# Step-by-Step Guide for Data Engineering Zoomcamp Project (local version)

This guide contains the instructions you need to follow to reproduce the project results:

[Step 0](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/Local_version/README.md#step-0---preparation) - Preparation

[Step 1](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/Local_version/README.md#step-1---creating-postgresql-database-and-environment-docker) - Creating PostgreSQL database and environment (docker)

[Step 2 and 3](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/Local_version/README.md#step-2-and-3---download-datasets-from-source-transform-it-and-upload-into-a-database-prefect--python) - Download datasets from source, transform it and upload into a database (prefect + python)

[Step 4](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/Local_version/README.md#step-4---transformation-modeling-and-generalization-of-data-into-a-database-dbt) - Transformation, modeling and generalization of data into a database (dbt)

[Step 5](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/Local_version/README.md#step-5---visualization-of-transformed-and-generalized-data-metabase) - Visualization of transformed and generalized data (metabase)

## Project architecture

1. Creating PostgreSQL database and environment (docker)
2. Download datasets from source (prefect + python)
3. Transformation and loading data into the database (prefect + python)
4. Transformation, modeling and generalization of data into a database (dbt)
5. Visualization of transformed and generalized data (metabase)

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/local-batch-processing.png)

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
Declare your mount volumes in docker-compose.yaml file. 

Run docker-compose from "1_docker" folder:

```
docker-compose up
```
This will create PostgreSQL database, pgadmin and metabase containers with defined in docker-compose.yaml logins and passwords.
For setup connection to PostgreSQL database via pgAdmin open http://localhost:8080 in browser, input login and password from docker-compose.yaml and setup server connection:

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/pgadmin_1.png)
![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/pgadmin_2.png)
![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/pgadmin_reg.png)


## Step 2 and 3 - Download datasets from source, transform it and upload into a database (prefect + python)
Run prefect orion service from "2_pipeline" folder:
```
prefect orion start
```
Go to http://127.0.0.1:4200/blocks and define SQLAlchemy Connector block like this:

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/sqlalch-conn-prefect.png)

```
"name": "psgres-connector", "driver": "postgresql+psycopg2", "database": "MVC_db",

"username": "root", "password": "root", "host": "localhost", "port": "5432"
```
Create prefect deployment file:
```
prefect deployment build ./pipeline.py:MVC_main -n MVC_flow
```
Open MVC_main-deployment.yaml file and make sure that "working_dir:" for download files is not empty (should be same as "path:" string in MVC_main-deployment.yaml file).

Apply new deployment:
```
prefect deployment apply MVC_main-deployment.yaml
```
Go to http://127.0.0.1:4200/deployments and edit parameters for downloading and processing data:

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/prefect_edit.png)

Select dataset for download:
  * "C" for Motor Vehicle Collisions - Crashes
  * "V" for Motor Vehicle Collisions - Vehicles
  * "P" for Motor Vehicle Collisions - Person 
  
Select years for partitioning and upload into database(separate table for each selected year) and save it. Years presented in the dataset:
```
[2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023]
```
![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/prefect_set_param.png)

Start prefect queue with name "default":
```
prefect agent start  --work-queue "default"
```
Data processing will start after uploading the CSV file. If the csv file was not completely downloaded, select data_type like "C reload"(example for "C" data type) and try again. It will start downloading the csv file with selected data type again.

Go to http://127.0.0.1:4200/flow-runs and check logs of started flow. If everything is done correctly, information about the processed data should appear in the logs:

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/prefect_logs.png)

After complete dataprocessing for all 3 datasets("C", "V" and "P"), set "check" for data_type and run this flow. 

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/prefect_check.png)

Data in the report should be like this:

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/prefect_check_res.png)

Make sure via pgAdmin, that all needed data was ingested in database(tables must be in "public" schema):

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/pgadmin_test.png)

## Step 4 - Transformation, modeling and generalization of data into a database (dbt)

Add info to profiles.yml from profiles.yml file.

Check the connection from "3_dbt" folder to database:
```
dbt debug
```
![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/dbt_debug.png)

Run dbt modeling:
```
dbt run
```
It should complete with 1 error:

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/dbt_error.png)

Run this dbt model again:

```
dbt run --select mvc_sum_all
```

Check new generalized tables in pgAdmin http://localhost:8080. They should be in the "MVC_summarize" schema.

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/pgdmin_summ.png)

## Step 5 - Visualization of transformed and generalized data (metabase)

Open Metabase  http://localhost:3001 and setup connection to database:

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/metabase_connect.png)

Create dashboard using sql queries from the [sqls.txt](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/Local_version/4_metabase/sqls.txt) file:

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/metabase-dashboard_1.png)
![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/metabase-dashboard_2.png)
