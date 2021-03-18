# AzureProject
Sample Project in Azure using Terraform

How to run this code. 

1. Install Azure CLI on your machine
2. provide login credentials using az login. 
3. Once login is successful. perform 
    a. terraform init. 
    b. terraform apply
    Note: assumption that terraform is already installed and configured and all terraform files related to the excercise are downloaded using 'git clone'

Question: To restrict particular user to have bastion host control and from particular IP address. 

We can use "Conditional access policy" for the operation. Terraform still doesn't have conditional access policy resource block. there is a gitlab request pending for it,"https://github.com/hashicorp/terraform-provider-azuread/issues/348". So until then we can use AZ CLI utility or Azure automation for it. 