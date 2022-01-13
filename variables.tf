variable "aws_region" {
  type = string
  description = "Region AWS"
}

variable "vpc_cidr" {
  type = string
}

variable "availability_zones_subnets" {
  type = list(string)
  description = "Availability zones for subnets"
  default = []
}

variable  "subnets_cidr" {
  type = list(string)
  description = "CIDR - Subnets"
  default = []
}

data "aws_availability_zones" "avz" {}