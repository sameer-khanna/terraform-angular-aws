terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "sameer-primary"

    workspaces {
      name = "threetierapp-prod"
    }
  }
}