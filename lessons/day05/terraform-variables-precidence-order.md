Terraform Variable Precedence Order (Lowest to Highest)
Environment variables

TF_VAR_<variable_name>

terraform.tfvars file

terraform.tfvars.json file

*.auto.tfvars and *.auto.tfvars.json files

Loaded automatically in lexical (alphabetical) order

-var and -var-file options on the command line

These override all other sources
