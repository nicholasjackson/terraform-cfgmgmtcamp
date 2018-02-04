resource "vault_auth_backend" "github" {
  type = "github"
}

# configure github backend to use organisation
resource "null_resource" "github_org" {
  provisioner "local-exec" {
    command = "vault write auth/${vault_auth_backend.github.path}/config organization=${var.github_org}"
  }
}

# configure github backend to add policy for user nicholasjackson
resource "null_resource" "github_user" {
  provisioner "local-exec" {
    command = "vault write auth/${vault_auth_backend.github.path}/map/users/nicholasjackson value=aws_readonly,aws_write"
  }
}
