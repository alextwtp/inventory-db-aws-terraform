terraform {
  backend "s3" {
    bucket         = "alextwtp-tfstate-20260825" 
    key            = "inventory-db/terraform.tfstate"  
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-locks"          
    encrypt        = true                       
    }
}