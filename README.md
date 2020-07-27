# Terraform

## Installation

    wget https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip
    sudo unzip terraform_0.12.24_linux_amd64.zip  -d /usr/local/bin/
    sudo chmod 755 /usr/local/bin/terraform

## Test

    terraform version

## Commandes de base

    apply              Builds or changes infrastructure
    destroy            Destroy Terraform-managed infrastructure
    import             Import existing infrastructure into Terraform
    init               Initialize a Terraform working directory
    plan               Generate and show an execution plan
    refresh            Update local state file against real resources
    show               Inspect Terraform state or plan
    validate           Validates the Terraform files

