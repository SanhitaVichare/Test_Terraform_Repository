#This file contains variables which are applicable on global level such as Tags/Custom VPC to create EC2 instances etc.

########################
#Global Input Arguments
#######################
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