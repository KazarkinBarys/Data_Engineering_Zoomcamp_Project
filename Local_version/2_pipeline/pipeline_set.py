from sqlalchemy.types import Integer, Date, Time,Text


url_C = "https://data.cityofnewyork.us/api/views/h9gi-nx95/rows.csv?accessType=DOWNLOAD"

sel_C = [
    "COLLISION_ID",
    "CRASH DATE",
    "CRASH TIME",
    "BOROUGH",
    "NUMBER OF PERSONS INJURED" ,
    "NUMBER OF PERSONS KILLED" ,
    "VEHICLE TYPE CODE 1",
    "CONTRIBUTING FACTOR VEHICLE 1",
    "VEHICLE TYPE CODE 2",
    "CONTRIBUTING FACTOR VEHICLE 2",
    "VEHICLE TYPE CODE 3",
    "CONTRIBUTING FACTOR VEHICLE 3",
    "VEHICLE TYPE CODE 4",
    "CONTRIBUTING FACTOR VEHICLE 4" 
]

sel_rename_C = {
    "COLLISION_ID" : "collision_id",
    "CRASH DATE" : "crash_date",
    "CRASH TIME" : "crash_time",
    "BOROUGH" : "borough",
    "NUMBER OF PERSONS INJURED" : "injured" ,
    "NUMBER OF PERSONS KILLED" : "killed" ,
    "CONTRIBUTING FACTOR VEHICLE 1" : "contr_f_vhc_1",
    "CONTRIBUTING FACTOR VEHICLE 2" : "contr_f_vhc_2",
    "CONTRIBUTING FACTOR VEHICLE 3" : "contr_f_vhc_3",
    "CONTRIBUTING FACTOR VEHICLE 4" : "contr_f_vhc_4",
    "VEHICLE TYPE CODE 1" : "vhc_1_code",
    "VEHICLE TYPE CODE 2" : "vhc_2_code",
    "VEHICLE TYPE CODE 3" : "vhc_3_code",
    "VEHICLE TYPE CODE 4" : "vhc_4_code"
}

sel_types_C = {

    "collision_id" : Integer(),
    "crash_date" : Date(),
    "crash_time" : Time(),
    "borough" : Text(),
    "injured" : Integer(),
    "killed" : Integer(),
    "vhc_1_code" : Text(),
    "contr_f_vhc_1" : Text(),
    "vhc_2_code" : Text(),
    "contr_f_vhc_2" : Text(),
    "vhc_3_code" : Text(),
    "contr_f_vhc_3" : Text(),
    "vhc_4_code" : Text(),
    "contr_f_vhc_4" : Text() 
}


url_V = "https://data.cityofnewyork.us/api/views/bm4k-52h4/rows.csv?accessType=DOWNLOAD"

sel_V = [
  "UNIQUE_ID" ,
  "COLLISION_ID" ,
  "CRASH_DATE" ,
  "CRASH_TIME" ,
  "VEHICLE_TYPE", 
  "VEHICLE_DAMAGE" ,
  "DRIVER_SEX" ,
  "DRIVER_LICENSE_STATUS" ,
  "VEHICLE_YEAR" ,
  "VEHICLE_OCCUPANTS" ,  
  "STATE_REGISTRATION" , 
  "CONTRIBUTING_FACTOR_1"
]

sel_rename_V = {
  "UNIQUE_ID" : "unique_id",
  "COLLISION_ID" : "collision_id",
  "CRASH_DATE" : "crash_date",
  "CRASH_TIME" : "crash_time",
  "STATE_REGISTRATION" : "state_reg",
  "VEHICLE_TYPE" : "vhc_type",
  "VEHICLE_YEAR" : "vhc_year",
  "VEHICLE_OCCUPANTS" : "vhc_occupants",
  "DRIVER_SEX" : "dr_sex",
  "DRIVER_LICENSE_STATUS" : "dr_lic_status",
  "VEHICLE_DAMAGE" : "vhc_dmg",
  "CONTRIBUTING_FACTOR_1" : "contr_f"
}

sel_types_V = {
  "unique_id" : Integer(),
  "collision_id" : Integer(),
  "crash_date" : Date(),
  "crash_time" : Time(),
  "vhc_type" : Text(),
  "vhc_dmg" : Text(),
  "dr_sex" : Text(),
  "dr_lic_status" : Text(),
  "vhc_year"  : Integer(),
  "vhc_occupants"  : Integer(),
  "state_reg" : Text(),
  "contr_f" : Text()
}


url_P = "https://data.cityofnewyork.us/api/views/f55k-p6yu/rows.csv?accessType=DOWNLOAD"

sel_P = [
  "UNIQUE_ID" ,
  "COLLISION_ID",
  "CRASH_DATE" ,
  "CRASH_TIME" ,
  "EJECTION" ,
  "BODILY_INJURY" ,
  "PERSON_INJURY" ,
  "POSITION_IN_VEHICLE" ,
  "SAFETY_EQUIPMENT" ,
  "PERSON_TYPE" ,
  "PERSON_AGE" ,
  "PERSON_SEX",
  "EMOTIONAL_STATUS" ,
  "CONTRIBUTING_FACTOR_1" 
   
]

sel_rename_P = {
 "UNIQUE_ID" : "unique_id",
  "COLLISION_ID" : "collision_id",
  "CRASH_DATE" : "crash_date",
  "CRASH_TIME" : "crash_time",
  "EJECTION" : "ejection",
  "BODILY_INJURY" : "body_inj",
  "PERSON_INJURY" : "person_inj",
  "POSITION_IN_VEHICLE" : "pos_in_vhc",
  "SAFETY_EQUIPMENT" : "safety_equip",
  "PERSON_TYPE" : "person_type",
  "PERSON_AGE" : "age",
  "PERSON_SEX" : "sex",
  "EMOTIONAL_STATUS" : "emot_status",
  "CONTRIBUTING_FACTOR_1" : "contr_f"
}

sel_types_P = {
  "unique_id" : Integer(),
  "collision_id" : Integer(),
  "crash_date" : Date(),
  "crash_time" : Time(),
  "ejection" : Text(),
  "body_inj" : Text(),
  "person_inj" : Text(),
  "pos_in_vhc" : Text(),
  "safety_equip" : Text(),
  "person_type" : Text(),
  "age" : Integer(),
  "sex" : Text(),
  "emot_status" : Text(),
  "contr_f" : Text()
}