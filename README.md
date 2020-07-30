# Useful commands
## AWS CLI
  - `aws configure list`: list current aws configurations and masked credentials. These details are stored in `~/.aws/credentials`

## Terraform
  - `terraform init`: pick up and download providers for configuration files present in directory
  - `terraform plan`: more less a dry run of the changes. shows a diff
  - `terraform apply`: apply changes
  - `terraform fmt`: format file
  - `terraform validate`: validate file
  - `terraform state list`: list states for manual state management
  - `terraform show`: show current state of deployed resource as stated in `terraform.tfstate`

### Gotchas
- Applying a config to using the wrong ids eg. the AMI ids in the wrong region would work but not create the instance at all...i.e. it fails quietly
- AWS regions can be a bitch!

### Best practices
- `.tf` files should be committed to vcs
- `.tfstate` files shouldn't be committed to vcs. They should only be shared with trusted be people who are to manage the resources defined. __For production it should be stored remotely using Terraform Cloud [TFC](https://learn.hashicorp.com/terraform/tfc/tfc_migration)__