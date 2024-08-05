# Configure the DigitalOcean Provider
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}

# Set the variable for your DigitalOcean API token
variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# Create a new Docker VPC
resource "digitalocean_vpc" "tic-tac-toe_vpc" {
  name   = "tic-tac-toe-vpc"
  region = "nyc3"
  ip_range = "10.10.10.0/24"
}

# Create a Kubernetes Cluster
resource "digitalocean_kubernetes_cluster" "tic-tac-toe" {
  name    = "tic-tac-toe-cluster"
  region  = "nyc3"
  version = "1.30.2-do.0"  # Use the latest version available

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"  # This is similar to t2.medium in terms of resources
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 2
  }

  vpc_uuid = digitalocean_vpc.tic-tac-toe_vpc.id
}
