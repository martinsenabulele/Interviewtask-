variable "network-vnet-cidr" {
  type        = string
  description = "The CIDR of the network VNET"
  default = "10.0.0.0/16"
}
variable "network-subnet-cidr-bastion" {
  type        = string
  description = "The CIDR for the network subnet for bastion"
  default = "10.0.0.0/24"
}

variable "network-subnet-cidr-frontend" {
  type        = string
  description = "The CIDR for the network subnet for frontend VMs"
  default = "10.0.1.0/24"
}

variable "network-subnet-cidr-backend" {
  type        = string
  description = "The CIDR for the network subnet for backend VMs"
  default = "10.0.2.0/24"
}

variable "network-subnet-cidr-bastionsubnet" {
  type        = string
  description = "The CIDR for the network subnet for backend VMs"
  default = "10.0.3.0/24"
}