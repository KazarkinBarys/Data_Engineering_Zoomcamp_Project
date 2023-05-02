

variable "region" {
    default= "us-east-1"
}


variable "ec2_ami" {
    default= "ami-007855ac798b5175e"
}


variable "key_name" {
    default= "zoomcamp_key"
}

variable "s3_bucket_name" {
    default= "zoomcamp-s3"
}



variable "namespace_name" {
    default= "zoomcamp-nmsp"
}

variable "db_user" {
    default= "zoomcamp-db-user"
}

variable "db_name" {
    default= "zoomcamp-db"
}

variable "db_password" {
    default= "pswrd"
}

variable "workgroup_name" {
    default= "zoomcamp-wrgr"
}

