variable "region" {

  default = "ap-south-1"

}

variable "access_key" {

  default = "AKIA5PHKRLUZYLN6E7YB"

}

variable "secret_key" {

  default = "kiKuJjzMOODhqq1lgmL8CjsObW5fxEzpKbYxnv5v"

}

variable "vpc_name" {

  default = "my-vpc"

}

variable "vpc_cidr_block" {

  default = "10.0.0.0/16"

}


variable "public_subnets_names" {

  type = list(string)

  default = ["subnet-public-1", "subnet-public-2"]

}

variable "private_subnet_name" {

  default = "subnet-private-1"

}


variable "public_subnet_cidr_blocks" {

  type = list(string)

  default = ["10.0.1.0/24", "10.0.2.0/24"]

}

variable "private_subnet_cidr_block" {

  default = "10.0.3.0/24"

}

variable "global_cidr_block" {

  default = "0.0.0.0/0"

}

variable "instance_type" {

  default = "t2.micro"

}

variable "key_name" {

  default = "mum.kp"

}


variable "ami" {

  default = "ami-02a2af70a66af6dfb"

}
