# AzureProject
Sample Project in Azure using Terraform

How to run this code. 

1. Install Azure CLI on your machine
2. provide login credentials using az login. 
3. Once login is successful. perform 
    a. terraform init.
    b. terraform plan ( to see your desire state) 
    c. terraform apply
    Note: assumption that terraform is already installed and configured and all terraform files related to the excercise are downloaded using 'git clone'

Question: To restrict particular user to have bastion host control and from particular IP address. 

We can use "Conditional access policy" for the operation. Terraform still doesn't have conditional access policy resource block. there is a gitlab request pending for it,"https://github.com/hashicorp/terraform-provider-azuread/issues/348". So until then we can use AZ CLI utility or Azure automation for it. 


Follow up questions:
How would you make this deployment fault tolerant and highly available? 
Azure Availabilty set/zone option will be use to ensure HA and fault tolerent 


How would you make this deployment more secure? 
For Secueirty enhancement will can use :
i. Native threat Detection (& SIEM) to simplify threat detection and response.
ii. Passwordless and multi-factor authentication(MFA) for strong authentication assurance
iii. Native firewall and network security for protection of systems and data, we can use Azure defender, Firewall and WAF.


How would you make this deployment cloud agnostic?
Using Infrastruture as Code (IaC) tools like Terraform to allow resuse of resources block 
