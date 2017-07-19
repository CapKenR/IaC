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
