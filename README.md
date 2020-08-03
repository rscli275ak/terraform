# Terraform

 * Infra as code : plan de déploiement décrit dans des fichiers HCL
 * Structure décarative / idempotence / diff état réel et `.tfstate`
 * Gère le cycle de vide des éléments d'une infra : firewall / container / VM / ...
 * Infra aas / PaaS / SaaS
 * Env. 160 providers : fournisseurs de ressources via API (https://registry.terraform.io)
 * 

## Ressource

 * Une ressource est un élement CRUD par le provider
 * Une reesource est un objet unique (nom unique) au sein d'un même module
 * Le type de la ressource est fourni par le provider

        ressource "type" "nom" {
            arg = "valeur"
        }

        ressource "aws_provider" "web" {
            ami = "some-ami-id"
            instance_type = "t2.micro"
        }

## Data source

 * Ressource non modifiable (en lecture seule, ex: images AWS)
 * Possibilité de filtrer

        data "aws_ami" "ubuntu" {
            most_recent = true
            filter {
                name = "name"
                values= ["yami-*"]
            }
        }

## Meta-Arguments

* Principe itératif

        ressource "type" "nom" {
            count = nb
            arg = "valeur"
        }

* Arrays

        variable "instances" {
            type = "map"
            default = {
                clef1 = "123"
                clef2 = "456"
                clef3 = "789"
            }
        }

        ressource "aws_instance" "server" {
            for_each = var.instances
            ami = each.value
            instance_type = "t2.micro"
            tags = {
                Name = each.key
            }
        }

## State

 * Stockage de l'état des ressources `terraform.tfstate`
 * Remote (permet de centraliser) : consul, S3, postgres

## Installation

    sudo apt-get update -y -qq && apt-get install wget unzip
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

## Déroulement

    terraform init
    terraform plan
    terraform apply

## Local-exec && Remote-exec

* utilisation des provisioners sur ces resources (passer des commandes)
	* provisioner `remote-exec` : exécution sur la machine distante
    * provisioner `local-exec` : exécution sur la machine terraform

* Types de variables : string, list, map
* `trigger` : vérifie les valeurs des listes

## Precedence ou niveaux de déclaration

* Définition à plusieurs niveaux : environnement jusqu'au fichier spécifique
* Terraform : 5 niveaux VS Ansible 22 niveaux

* Ordre des variables
	* 1 - environnement

            export TF_VAR_str="env"
            terraform apply

	* 2 - fichier : terraform.tfvars

            echo 'str="terraform"'> terraform.tfvars

	* 3 - fichier json : terraform.tfvars.json
	* 4 - fichier \*.auto.tfvars ou \*.auto.tfvars.json

            echo 'str="auto"'> production.auto.tfvars

	* 5 - CLI : -var ou - var-file

            terraform apply -var "str=cli"
            terraform apply -var "str=cli" -var-file varfile.tfvars

        -> Prend toujours l'argument le plus à gauche en priorité