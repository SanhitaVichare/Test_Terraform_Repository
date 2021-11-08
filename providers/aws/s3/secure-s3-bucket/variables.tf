# This file contains variable definitions to create a secure S3 bucket with all CIS Benchmark and CSA recommendations

variable "mandatory_tag_owner" {
  type 		  = string
  description = "This variable must contain owner name/arn"
}

variable "mandatory_tag_description" {
  type 		  = string
  description = "This variable must contain the project name"
}

variable "mandatory_tag_code" {
  type 		  = string
  description = "This variable must contain the project code"
}


variable "server_logging_bucket_name" {}