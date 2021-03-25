# company name 
variable "company" {
  type        = string
  description = "The company name used to build resources"
  default     = "azure"
}
# application name 
variable "app_name" {
  type        = string
  description = "The application name used to build resources"
  default     = "microapplication"
}
# environment
variable "environment" {
  type        = string
  description = "The environment to be built"
  default     = "linux"
}
# azure region
variable "location" {
  type        = string
  description = "Azure region where the resources will be created"
  default     = "eastus"
}