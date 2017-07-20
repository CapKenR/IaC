variable "user" {}
variable "password" {}
variable "location" { default = "westcentralus" }
variable "environment" { default = "Test" }
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "ucp_count" { default = 3 }
variable "dtr_count" { default = 3 }
variable "wnw_count" { default = 2 }
variable "wnl_count" { default = 2 }
variable "docker_url" { default = "https://storebits.docker.com/ee/linux/sub-0fc42e50-bfbc-4e66-8789-841113d6130d" }
