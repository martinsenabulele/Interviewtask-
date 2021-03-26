# Data template Bash bootstrapping file
data "template_file" "linux-vm-frontend-init" {
  template = file("azure-frontend-data.sh")
}

# Data template Bash bootstrapping file
data "template_file" "linux-vm-backend-init" {
  template = file("azure-backend-data.sh")
}