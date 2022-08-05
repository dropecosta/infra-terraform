terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Create a web server
resource "digitalocean_kubernetes_cluster" "aula-iniciativa" {
  name   = var.aula_name
  region = var.region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.23.9-do.0"

  node_pool {
    name       = "default"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}

variable "do_token" {}
variable "aula_name" {}
variable "region" {}

output "kube_endpoint" {
    value = digitalocean_kubernetes_cluster.aula-iniciativa.endpoint
}

resource "local_file" "foo" {
    content  = digitalocean_kubernetes_cluster.aula-iniciativa.kube_config.0.raw_config
    filename = "kube=config.yaml"
}