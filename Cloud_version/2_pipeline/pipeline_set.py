
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
    "collision_id" : 'int',
    "crash_date" : 'date',
    "crash_time" : 'timestamp',
    "borough" : 'string',
    "injured" : 'int',
    "killed" : 'int',
    "vhc_1_code" : 'string',
    "contr_f_vhc_1" : 'string',
    "vhc_2_code" : 'string',
    "contr_f_vhc_2" : 'string',
    "vhc_3_code" : 'string',
    "contr_f_vhc_3" : 'string',
    "vhc_4_code" : 'string',
    "contr_f_vhc_4" : 'string' 
}

table_schem_C = '''( "collision_id"  integer,
    "crash_date" date,
    "crash_time" timestamp,
    "borough"  varchar (15),
    "injured" integer,
    "killed" integer,
    "vhc_1_code" varchar (50),
    "contr_f_vhc_1" varchar(60),
    "vhc_2_code" varchar(50),
    "contr_f_vhc_2" varchar(60),
    "vhc_3_code" varchar(50),
    "contr_f_vhc_3" varchar(60),
    "vhc_4_code" varchar(50),
    "contr_f_vhc_4" varchar(60) 
)'''


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
  "unique_id" : 'int',
  "collision_id" : 'int',
  "crash_date" : 'date',
  "crash_time" : 'timestamp',
  "vhc_type" : 'string',
  "vhc_dmg" : 'string',
  "dr_sex" : 'string',
  "dr_lic_status" : 'string',
  "vhc_year"  : 'int',
  "vhc_occupants"  : 'int',
  "state_reg" : 'string',
  "contr_f" : 'string'
}

table_schem_V = '''( "unique_id" integer,
    "collision_id" integer,
    "crash_date" date,
    "crash_time" timestamp,
    "vhc_type" varchar (50),
    "vhc_dmg" varchar (40),
    "dr_sex" varchar (3),
    "dr_lic_status" varchar (15),
    "vhc_year"  integer,
    "vhc_occupants"  integer,
    "state_reg" varchar (5),
    "contr_f" varchar (60)
)'''



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
  "unique_id" : 'int',
  "collision_id" : 'int',
  "crash_date" : 'date',
  "crash_time" : 'timestamp',
  "ejection" : 'string',
  "body_inj" : 'string',
  "person_inj" : 'string',
  "pos_in_vhc" : 'string',
  "safety_equip" : 'string',
  "person_type" : 'string',
  "age" : 'int',
  "sex" : 'string',
  "emot_status" : 'string',
  "contr_f" : 'string'
}

table_schem_P = '''( "unique_id" integer,
    "collision_id" integer,
    "crash_date" date,
    "crash_time" timestamp,
    "ejection" varchar (20),
    "body_inj" varchar (30),
    "person_inj" varchar (20),
    "pos_in_vhc" varchar ,
    "safety_equip" varchar (50),
    "person_type" varchar (20),
    "age" integer,
    "sex" varchar (3),
    "emot_status" varchar (20),
    "contr_f" varchar (60)
)'''

