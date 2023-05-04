# Data_Engeneering_Zoomcamp_Project

## Overview

This project was executed as a part of the [Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp) course held by [DataTalks.Club](https://datatalks.club/). 

The end goal of this project is to apply everything we learned in this course and build an end-to-end data pipeline. The project is implemented in two versions: local and cloud.

The goals of the project are:

  * develop end-to-end data pipeline that will help to organize data processing in a batch manner;
  * develop dbt models to prepare data for the required analytical purposes;
  * build analytical dashboard that will make it easy to discern the trends and digest the insights;
  * develop a script to autocomplete the dashboard according to the desired template;
  * implement in two versions with different technologies: local and cloud.
  
The period of the data processing will cover from 2012 to 2023.

## Datasets used in the project

[Motor Vehicle Collisions - Crashes](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Crashes/h9gi-nx95) data shows information about each traffic crash event on city streets within the New York City.  Each row represents a crash event. The Motor Vehicle Collisions data tables contain information from all police reported motor vehicle collisions in NYC. The police report (MV104-AN) is required to be filled out for collisions where someone is injured or killed, or where there is at least $1000 worth of damage.

[Motor Vehicle Collisions - Vehicles](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Vehicles/bm4k-52h4) data contains details on each vehicle involved in the crash. Each row represents a motor vehicle involved in a crash. 

[Motor Vehicle Collisions - Person](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Person/f55k-p6yu) data contains details for people involved in the crash. Each row represents a person (driver, occupant, pedestrian, bicyclist,..) involved in a crash.

Data are shown as is from the electronic crash reporting system, excluding any personally identifiable information.

## Problem description and purposes

The project is related Motor Vehicle Collisions in New York and is based on data from 3 datasets. 

Need to analyze: what types of cars most often get into collisions, for what reasons collisions took place, at what time of the day accidents most often occur, the age and gender of the drivers involved in collisions. 

Also need to find out how complete the datasets are: how many cars, people and other data is unknown. 

For realize this purposes in cloud version need to:
  * develop a template to automatically launch the necessary cloud infrastructure(elastic compute cloud, datalake and datawarehouse);
  * create a data pipeline for extract raw data from a source, transform it and upload into datalake and then upload from datalake to datawarehouse;
  * uploaded data must be partitioning on years;
  * generalize data for analytics:
 
       - for each year; 
       - for daytime(hourly); 
       - for missing data;
  * create a dashboard with generalized data;
  * create a script for creating dashboard automatically.

## Technologies used in Cloud version

  * Infrastructure as code (IaC): Terraform
  * Compute and flow control: AWS EC2
  * Containerization: Docker
  * Batch Orchestration: Prefect + Python
  * Primary data processing: Spark
  * Datalake: AWS S3
  * Datawarehouse: AWS RedShift
  * Data Transformation and Generalization : DBT
  * Visualisation: Metabase

## Project architecture (Cloud version)

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

## Final Analytical Dashboard:

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/26_metabase_dashboard_1.jpg)
![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Cloud/26_metabase_dashboard_2.jpg)

## Step-by-Step Guide for Data Engineering Zoomcamp Project (Cloud version)

This guide contains the instructions you need to follow to reproduce the project results.

Follow instructions [here](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/tree/main/Cloud_version)

## Technologies used in Local version

  * Containerization: Docker
  * Data Base: PostreSQL
  * Batch Orchestration: Prefect + Python
  * Data Transformation and Generalization : DBT
  * Visualisation: Metabase

## Project architecture (Local version)

1. Creating PostgreSQL database and environment (docker)
2. Downloading datasets from source (prefect + python)
3. Transformation and loading data into the database (prefect + python)
4. Transformation, modeling and generalization of data into a database (dbt)
5. Visualization of transformed and generalized data (metabase)

![alt text](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/local-batch-processing.png)


## Step-by-Step Guide for Data Engineering Zoomcamp Project (Local version)

This guide contains the instructions you need to follow to reproduce the project results.

Follow instructions [here](https://github.com/KazarkinBarys/Data_Engineering_Zoomcamp_Project/tree/main/Local_version)
