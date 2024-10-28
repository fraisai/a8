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

/*
    *terraform { backend "s3" { ... } }: Configures Terraform to use an S3 bucket as the backend for storing the state file (terraform.tfstate). A backend manages where and how the Terraform state is stored.

    encrypt = true: Ensures that the state file stored in S3 is encrypted at rest using server-side encryption.

    bucket = "fariha-a8-bucket": Specifies the name of the S3 bucket (fariha-a8-bucket) where Terraform will store its state file.

    dynamodb_table = "tf-state-lock-dynamo": Points to a DynamoDB table (tf-state-lock-dynamo) used to lock the state file during Terraform operations, which prevents concurrent modifications and avoids conflicting changes.

    key = "terraform.tfstate": Sets the name of the state file in S3. Here, it will be stored as terraform.tfstate within the specified bucket.
*/
# Configures Terraform to use an S3 bucket as the backend for storing the state file (terraform.tfstate).
# look into: terraform init -backend-config="" backend.hcl
terraform {
  backend "s3" {
    encrypt = true    
    bucket = "fariha-a8-bucket"
    dynamodb_table = "tf-state-lock-dynamo"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }
}


/*
    hash_key = "LockID": Defines LockID as the primary partition key for the table, ensuring each item in the table has a unique identifier.

    read_capacity = 1 and write_capacity = 1: Specifies the read and write capacities (in capacity units) for the table. Setting both to 1 is sufficient for a low-traffic Terraform locking table.

    attribute { ... }: Describes the schema of attributes in the table.
        - name = "LockID": Specifies LockID as the name of the attribute, which is used as the hash key.
            - In DynamoDB, the primary partition key is the main identifier that uniquely defines each item in a table. By setting LockID as the primary partition key in the tf-state-lock-dynamo table, DynamoDB ensures each entry in this table is uniquely identified by its LockID value

    type = "S": Sets the type of the LockID attribute to S, which stands for string type in DynamoDB.
*/
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

