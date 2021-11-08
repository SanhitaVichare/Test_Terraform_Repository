# This file contains resource to create a server logging S3 bucket with all CIS Benchmark and CSA recommendations

#This resource is used to create S3 server logging bucket
resource "aws_s3_bucket" "server_logging_bucket" {
  bucket = "terraform-server-logging-bucket"
  acl    = "log-delivery-write"
  versioning {
    enabled = true
  }

   object_lock_configuration {
    object_lock_enabled = "Enabled"
    rule {
      default_retention {
	    mode = "GOVERNANCE"
		days = "365"
	  }
	}	
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn:aws:kms:us-east-1:412164052405:key/244e91df-40b5-409f-b5f4-5ce7e3a3b6fd"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    OWNER       = "arn:aws:sts::412164052405:assumed-role/LabAWSAdmin/sadhuprakash@testing-labs.net"
    DESCRIPTION = "Demo Resource to Delete"
	CODE        = "NA"

  }
}

#This resource is used to setup S3 server logging bucket public access block configuration
resource "aws_s3_bucket_public_access_block" "server_logging_bucket" {
  bucket 				  = aws_s3_bucket.server_logging_bucket.id

  block_public_acls   	  = true
  block_public_policy 	  = true
  ignore_public_acls  	  = true
  restrict_public_buckets = true

  depends_on = [
    aws_s3_bucket_policy.server_logging_bucket
  ]
}

resource "aws_s3_bucket_policy" "server_logging_bucket" {
  bucket = aws_s3_bucket.server_logging_bucket.id

  #policy = file("./providers/aws/s3/server-logging-bucket/server_logging_bucket_policy.json")
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "MYBUCKETPOLICY",
  "Statement": [
    {
      "Sid": "Statement1",
      "Effect": "Allow",
      "Principal": {
         "Service": [
            "s3.amazonaws.com",
            "logs.us-east-1.amazonaws.com"
         ]
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "${aws_s3_bucket.server_logging_bucket.arn}"
    },
	{
      "Sid": "Statement2",
      "Effect": "Allow",
      "Principal": {
         "Service": [
            "s3.amazonaws.com",
            "logs.us-east-1.amazonaws.com"
         ]
      },
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.server_logging_bucket.arn}/*",
	  "Condition":{
         "StringEquals":{
            "s3:x-amz-acl":"bucket-owner-full-control"
         }
      }
    }
  ]
}
POLICY
}


output "server_logging_bucket_name" {
  value  = aws_s3_bucket.server_logging_bucket.id
  description  = "This output variable holds the S3 server logging bucket name which can be referrenced in other resources"
}

output "server_logging_bucket_arn" {
  value  = aws_s3_bucket.server_logging_bucket.arn
  description  = "This output variable holds the S3 server logging bucket arn which can be referrenced in other resources"
}