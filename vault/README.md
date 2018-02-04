## Using Terraform module
GitHub authentication can be configured using the Terraform Vault provider, to configure Vault using this Terraform module
add the following stanza to your Terraform config

```hcl
provider "vault" {
  address = "http://pi01.local.demo.gs:8200"
}

module "vault" {
  source = "./vault"

  github_org            = "hashicorp"

  aws_access_key_id     = "xxxxxxxxxxxxxx"
  aws_access_key_secret = "xxxxxxxxxxxxxxxxxxxxxx"
  aws_region            = "us-east-1"
}
```

## Configuring Vault using command line

### Mount AWS backend
```bash
vault secrets enable aws

vault write aws/config/root \
    access_key=AKIAJWVxxxxxxxxxxxx \
    secret_key=R4nm063hgMVo4BTT5xOs5nHLxxxxxxxxxxxxxx \
    region=us-east-1
```

### Add roles for AWS accounts
```bash
vault write aws/roles/aws_readonly policy=@./templates/aws_read_policy.json
vault write aws/roles/aws_write policy=@./templates/aws_write_policy.json
```

### Fetching dynamic user accounts
```bash
vault read aws/creds/aws_readonly
vault read aws/creds/aws_write
```

### Create policy
```bash
vault write sys/policy/aws_write policy=@./templates/aws_write.hcl
vault write sys/policy/aws_readonly policy=@./templates/aws_readonly.hcl
```

### Assign policy to github user
```bash
vault write auth/github/map/users/nicholasjackson value=aws_readonly,aws_write
```

## Running on CI
Note: envconsul is used in this example to inject environment variables into the Terraform
proccess, however it would also be possible to modify this script to set environment
variables directly using pure bash

Generate vault token with Github login
```bash
export VAULT_TOKEN=$(vault login -token-only -method=github token=${GITHUB_TOKEN}) 
```

Running `terraform plan` with AWS read credentials
```bash
export VAULT_TOKEN=$(vault login -token-only -method=github token=${GITHUB_TOKEN}) 
export VAULT_ADDR=http://pi01.local.demo.gs:8200 
envconsul -secret aws/creds/aws_readonly -once ../run_terraform.sh plan -out=plan/plan.out
```

Running `terraform apply` with AWS write credentials
```bash
export VAULT_TOKEN=$(vault login -token-only -method=github token=${GITHUB_TOKEN}) 
export VAULT_ADDR=http://pi01.local.demo.gs:8200 
envconsul -secret aws/creds/aws_write -once ../run_terraform.sh apply plan/plan.out
```
