# Prerequisites
## Configuring AWS API Credentials
- Create an access key in your IAM account from the AWS console
- Save the access key credentials in your local machine at ~/.aws/credentials following the format below
```
[default]
aws_access_key_id=${ACCESS_KEY_ID}
aws_secret_access_key=${SECRET_ACCESS_KEY}
```

# Project Structure
This project aims to duplicate AWS infrastructure across environments.
- To initialize an environment, run `terraform init` from the target directory (i.e. src/environments/blue).
- To create or update an environment, run `terraform apply` from the target directory (i.e. src/environments/development).
## Templates
Templates contain the infrastructure blueprint.
## Environments
Environments are targets for infrastructure provisioning.
## Development
- Changes to infrastructure must be done from `templates` directory.
- Once changes are ready for use, these should be symbolically linked into the environments directory. To do this run `cd src/environment/<env>; ln -s ../../templates/* ./.`
## Running
- It is expected that AMIs have been generated from the `packer` project. Update the environment `terraform.tfvars` file with the appropriate AMI ids.
- Change directory to the target environment and run `terraform apply`.

