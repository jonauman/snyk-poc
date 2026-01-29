variable "project_id" {
  description = "GCP project ID where resources will be created."
  type        = string
}

variable "region" {
  description = "GCP region for the subnet."
  type        = string
  default     = "europe-west2"
}

variable "vpc_name" {
  description = "Name of the VPC network."
  type        = string
  default     = "this-vpc"
}

variable "subnet_name" {
  description = "Name of the subnet."
  type        = string
  default     = "this-subnet"
}

variable "vpc_cidr" {
  description = "CIDR range for the VPC (used for documentation/validation only)."
  type        = string
  default     = "10.1.1.0/24"
}

variable "subnet_cidr" {
  description = "CIDR range for the subnet."
  type        = string
  default     = "10.1.1.128/25"
}

variable "subnet_logging_config" {
  description = "VPC flow log configuration for the subnet."
  type = object({
    aggregation_interval = string
    flow_sampling        = number
    metadata             = string
  })
  default = {
    aggregation_interval = "INTERVAL_5_SEC"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
}
