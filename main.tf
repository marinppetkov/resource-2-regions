terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.30.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

resource "random_pet" "instance_name" {
  count=2
  length = 1
}

module vm_deploy_west{
    source = "git::https://github.com/marinppetkov/simple-tfc-module.git?ref=1.0.0"
    instance_tag = random_pet.instance_name[0].id
    providers = {
    aws = aws.west
  }
}

module vm_deploy_east{
    source = "git::https://github.com/marinppetkov/simple-tfc-module.git?ref=1.0.0"
    instance_tag = random_pet.instance_name[1].id
}
