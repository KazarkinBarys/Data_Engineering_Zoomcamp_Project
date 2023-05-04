# Step-by-Step Guide for Data Engineering Zoomcamp Project (Cloud version)

This guide contains the instructions you need to follow to reproduce the project results:

[Step 0](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/tree/main/Cloud_version#step-0---preparation) - Preparation

[Step 1](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/tree/main/Cloud_version#step-1---creating-cloud-infrastructure-on-aws---ec2-s3-bucket-redshift-serverless-cluster-terraform) - Creating cloud infrastructure on AWS - EC2, S3 bucket, RedShift serverless cluster (terraform)

[Step 2](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/tree/main/Cloud_version#step-2---installing-docker-and-run-containers-on-aws-ec2-instance-docker) - Installing docker and run containers on AWS EC2 instance (docker)

[Step 3,4,5 and 6](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/tree/main/Cloud_version#step-345-and-6---run-prefect-flows-to-download-datasets-from-source-transform-it-with-spark-upload-into-a-s3-and-from-s3-to-redshift-prefect-python-spark) - Run prefect flows to download datasets from source, transform it with spark, upload into a S3, and from S3 to RedShift (prefect, python, spark)

[Step 7](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/tree/main/Cloud_version#step-7---transformation-modeling-and-generalization-data-in-the-redshift-dbt) - Transformation, modeling and generalization data in the RedShift (dbt)

[Step 8 and 9](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/tree/main/Cloud_version#step-8-and-9---visualization-of-transformed-and-generalized-data-metabase) - Visualization of transformed and generalized data (metabase)


## Project architecture

1. Creating Cloud infrastructure: EC2, S3 bucket, Redshift cluster (Terraform)
2. Containerization: Creating containers with the necessary tools: python, prefect, spark, metabase, etc (docker)
3. Downloading datasets from source (prefect + python)
4. Primary data transformation and saving it into parquet files (spark)
5. Uploading parquet files into the datalake S3 (prefect + python)
6. Creating tables and uploaded data into them from S3 (prefect + python)
7. Transformation, modeling and generalization of data into a database (dbt)
8. Creation dashboard template and filling it with data from datawarehouse (metabaseApi + python)
9. Visualization of transformed and generalized data (metabase)

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/image.png)

## Step 0 - preparation
Need to be installed:
  * Terraform
  * Visual Studio Code(or analogue)
  
  
## Step 1 - creating cloud infrastructure on AWS - EC2, S3 bucket, RedShift serverless cluster (terraform)
Set variables in variables.tf file

Run terraform commands:
```
terraform init
terraform plan
terraform apply
```
Check created AWS infrastructure - terraform must create EC2 instance, s3 bucket, RedShift serverless cluster and all necessary connections(subnets, security groups, internet gateways, etc)

## Step 2 - installing docker and run containers on AWS EC2 instance (docker)
Connect to EC2 instance with VSCode and copy 'Cloud_version' folder to it:

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/1_copy_to_ec2.jpg)

Install docker and docker-compose using instructions from file docker_setup.txt

Create docker image from docker file:
```
docker build  -t zoomcamp .
```
Run docker-compose:
```
docker-compose up
```
Go inside docker container:
```
docker ps
docker exec -it [CONTAINER ID] /bin/bash
```
![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/2_go_into_container.jpg)

Apply prefect flows:
```
prefect deployment apply MVC_main-deployment.yaml
prefect deployment apply metabase-deployment.yaml
```
![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/3_.jpg)

Start prefect orion:
```
prefect orion start --host 0.0.0.0

```
![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/4_.jpg)

Start prefect agent:
```
prefect agent start  --work-queue "default"
```
![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/5_prefect_agent_start.jpg)

Go to http://localhost:4200/blocks/catalog and set the block with AWS credentials:

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/6_prefect_aws_block.jpg)

Block name must be 'awscre':

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/7_prefect_aws_block.jpg)

## Step 3,4,5 and 6 - run prefect flows to download datasets from source, transform it with spark, upload into a S3, and from S3 to RedShift (prefect, python, spark)
Go to http://localhost:4200/deployments click quick run on MVC_flow and set parameters for downloading and processing data:
![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/8_prefect_run.jpg)
![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/9_C_prefect_run.jpg)

Select datatype for download:
  * "C" for Motor Vehicle Collisions - Crashes
  * "V" for Motor Vehicle Collisions - Vehicles
  * "P" for Motor Vehicle Collisions - Person 
 
Select years for partitioning and upload into database(separate table for each selected year) and save it. Years presented in the dataset:
```
[2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023]
```

Data processing will start after uploading the CSV file. If the csv file was not completely downloaded, select data_type like "C reload"(example for "C" data type) and try again. It will start downloading the csv file with selected data type again.

Go to http://localhost:4200/flow-runs and check logs of started flow. If everything is done correctly, information about the processed data should appear in the logs.

Spark reads the CSV file, selects the desired data, and writes it to the parquet file:

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/10_C_parq_prefect_run.jpg)

Parquet files uploading into S3 bucket:

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/11_C_s3_prefect_run.jpg)

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/12_C_s3_prefect_run.jpg)

Creation tables into RedShift and insert data from S3 parquet files:

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/13_C_redshift_prefect_run.jpg)

After complete dataprocessing for all 3 datasets("C", "V" and "P"), set "check" for data_type and run this flow. 

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/14_pref_check_redshift_prefect_run.jpg)

The data report should look like this:

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/14_pref_res_check_redshift_prefect_run.jpg)

Make sure via RedShift QueryTool, that all needed data was ingested in database(tables must be in "public" schema):

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/14_qcheck_redshift_prefect_run.jpg)


## Step 7 - transformation, modeling and generalization data in the RedShift (dbt)

Add info(host and password) to profiles.yml file(in 3_dbt folder).
Host u can check on AWS Redshift Workgroup configuration(endpoint):

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/15_dbt_redshift_prefect_run.jpg)

Go to http://localhost:4200/deployments click quick run on MVC_flow and set "dbt" as data_type for run dbt processing:

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/16_dbt_run_redshift_prefect_run.jpg)

Check new generalized tables via RedShift QueryTool. They should be in the "MVC_summarize" schema.

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/17_dbt_run_redshift_prefect_run.jpg)

## Step 8 and 9 - visualization of transformed and generalized data (metabase)

Open Metabase  http://localhost:3000, set login, password for metabase and setup connection to RedShift (set database name: "MVC_db"):

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/18_metabase_reg_db.jpg)

Check the data in MVC_db database:

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/19_metabase_check_db.jpg)

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/20_metabase_check_db.jpg)

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/21_metabase_check_db.jpg)

Go to http://localhost:4200/deployments click quick run on metabase_flow and set login and password from metabase:
![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/22_metabase_prefect_ru.jpg)

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/23_metabase_prefect_ru.jpg)

The flow output should look like this:

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/24_metabase_prefect_ru.jpg)

If u have troubles with connection - check metabase container ip with bash command:
```
docker inspect   -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' [CONTAINER ID]
```
And add this ip adress as 3 value to login and password in metabase_flow setup.

Go to metabase http://localhost:3000/ and check MVC_collection:
![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/25_metabase.jpg)

Checkout MVC_dashboard:
![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/26_metabase_dashboard_1.jpg)
![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/26_metabase_dashboard_2.jpg)

