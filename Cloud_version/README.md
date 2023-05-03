# Step-by-Step Guide for Data Engineering Zoomcamp Project (Cloud version)

This guide contains the instructions you need to follow to reproduce the project results:

[Step 0](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/Local_version/README.md#step-0---preparation) - Preparation

[Step 1](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/Local_version/README.md#step-1---creating-postgresql-database-and-environment-docker) - Creating PostgreSQL database and environment (docker)

[Step 2 and 3](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/Local_version/README.md#step-2-and-3---download-datasets-from-source-transform-it-and-upload-into-a-database-prefect--python) - Download datasets from source, transform it and upload into a database (prefect + python)

[Step 4](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/Local_version/README.md#step-4---transformation-modeling-and-generalization-of-data-into-a-database-dbt) - Transformation, modeling and generalization of data into a database (dbt)

[Step 5](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/Local_version/README.md#step-5---visualization-of-transformed-and-generalized-data-metabase) - Visualization of transformed and generalized data (metabase)

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
  
  
## Step 1 - creating cloud infrastructure on AWS - EC2, S3 bucket, RedShift serverless cluster(Terraform)
Set variables in variables.tf file

Run terraform commands:
```
terraform init
terraform plan
terraform apply
```
Check created AWS infrastructure - terraform must create EC2 instance, s3 bucket, RedShift serverless cluster and all necessary connections(subnets, security groups, internet gateways, etc)

## Step 2 - installing docker and run containers on AWS EC2 instance
Connect to EC2 instance and copy 'Cloud_version' folder:

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

Go to localhost:4200 and set the block with AWS credentials:

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/6_prefect_aws_block.jpg)

Block name must be 'awscre':

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/7_prefect_aws_block.jpg)
