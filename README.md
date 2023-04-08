# Data_Engeneering_Zoomcamp_Project

## Overview

This project was executed as a part of the [Data Engineering Zoomcamp](https://github.com/DataTalksClub/data-engineering-zoomcamp) course held by [DataTalks.Club](https://datatalks.club/). The goal of this project is to apply everything we learned in this course and build an end-to-end data pipeline.

The goals of the project are:

  * develop a data pipeline that will help to organize data processing in a batch manner;
  * build analytical dashboard that will make it easy to discern the trends and digest the insights.
The period of the data processing will cover from 2012 to 2023.


## Problem description and purposes

The project is related Motor Vehicle Collisions in New York and is based on data from 3 datasets. 

Need to analyze: what types of cars most often get into collisions, for what reasons collisions took place, at what time of the day accidents most often occur, the age and gender of the drivers involved in collisions. 

Also need to find out how complete the datasets are: how many cars, people and other data is unknown. 

For this purposes need to:
  * create database for store and processing the data;
  * create a data pipeline for extract raw data from a source, transform it and upload into database;
  * uploaded data must be partitioning on years;
  * generalize data for analytics;
  * creating a dashboard with generalized data.

## Datasets used in the project

[Motor Vehicle Collisions - Crashes](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Crashes/h9gi-nx95) data shows information about each traffic crash event on city streets within the New York City.  Each row represents a crash event. The Motor Vehicle Collisions data tables contain information from all police reported motor vehicle collisions in NYC. The police report (MV104-AN) is required to be filled out for collisions where someone is injured or killed, or where there is at least $1000 worth of damage.

[Motor Vehicle Collisions - Vehicles](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Vehicles/bm4k-52h4) data contains details on each vehicle involved in the crash. Each row represents a motor vehicle involved in a crash. 

[Motor Vehicle Collisions - Person](https://data.cityofnewyork.us/Public-Safety/Motor-Vehicle-Collisions-Person/f55k-p6yu) data contains details for people involved in the crash. Each row represents a person (driver, occupant, pedestrian, bicyclist,..) involved in a crash.

Data are shown as is from the electronic crash reporting system, excluding any personally identifiable information.

## Technologies used

  * Containerization: Docker
  * Data Base: PostreSQL
  * Batch Orchestration: Prefect + Python
  * Data Transformation and Generalization : DBT
  * Visualisation: Metabase

## Project architecture

1. Creating PostgreSQL database and environment (docker)
2. Download datasets from source (prefect + python)
3. Transformation and loading data into the database (prefect + python)
4. Transformation, modeling and generalization of data into a database (dbt)
5. Visualization of transformed and generalized data (metabase)

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/local-batch-processing.png)

## Final Analytical Dashboard:

![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/metabase-dashboard_1.png)
![alt text](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/blob/main/images/Local/metabase-dashboard_2.png)

## Step-by-Step Guide for Data Engineering Zoomcamp Project (local version)

This guide contains the instructions you need to follow to reproduce the project results.

Follow instructions [here](https://github.com/kostoccka/Data_Engineering_Zoomcamp_Project/tree/main/Local_version)
