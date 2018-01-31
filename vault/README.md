## Add roles for AWS accounts
```bash
vault write aws/roles/aws_readonly policy=@aws_read_policy.json
vault write aws/roles/aws_write policy=@aws_write_policy.json
```

## Fetching dynamic user accounts
```
vault read aws/creds/aws_readonly
vault read aws/creds/aws_write
```

## Create policy
```
vault write sys/policy/aws_write policy=@aws_write.hcl
vault write sys/policy/aws_readonly policy=@aws_readonly.hcl
```

## Assign policy to github user
```
vault write auth/github/map/users/nicholasjackson value=aws_readonly,aws_write
```

## Generate vault token with Github login
```
export VAULT_TOKEN=$(vault login -token-only -method=github token=${GITHUB_TOKEN}) 
```

```
export VAULT_TOKEN=$(vault login -token-only -method=github token=${GITHUB_TOKEN}) 
export VAULT_ADDR=http://pi01.local.demo.gs:8200 
envconsul -secret aws/creds/aws_readonly -once ./run_terraform.sh plan -out=plan/plan.out
```

```
export VAULT_TOKEN=$(vault login -token-only -method=github token=${GITHUB_TOKEN}) 
export VAULT_ADDR=http://pi01.local.demo.gs:8200 
envconsul -secret aws/creds/aws_write -once ./run_terraform.sh apply plan/plan.out
```
