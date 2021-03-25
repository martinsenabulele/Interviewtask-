# Data template Bash bootstrapping file
data "template_file" "linux-vm-cloud-init" {
  template = file("azure-user-data.sh")
}

# Data template Bash bootstrapping file
data "template_file" "linux-vm-back-init" {
  template = file("azure-back-data.sh")
}