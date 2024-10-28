module "a8_ec2_instance" {
  source        = "./modules/ec2_instance"
}

#s3 bucket
resource "aws_s3_bucket" "a8_bucket" {
    bucket = "fariha-a8-bucket"

    tags = {
        Name = "fariha-a8-state"
    }
}

terraform {
  backend "s3" {
    encrypt = true    
    bucket = "fariha-a8-bucket"
    dynamodb_table = "tf-state-lock-dynamo"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}

resource "aws_dynamodb_table" "a8_dynamo" {
    name = "tf-state-lock-dynamo"
    hash_key = "LockID"
    read_capacity = 1
    write_capacity = 1
    attribute {
        name = "LockID"
        type = "S"
    }
}

