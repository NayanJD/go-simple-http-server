terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}


# Define variable for DO token
variable "do_token" {
  description = "DigitalOcean API Token"
  type        = string
  sensitive   = true
  default     = null # Allow it to be optional
}

# Define variable for SSH key IDs
variable "ssh_key_ids" {
  description = "List of DigitalOcean SSH key IDs"
  type        = list(string)
  default     = [] # Empty list as default
}

# Configure the provider with token from environment variable
# Will use DIGITALOCEAN_TOKEN by default, or TF_VAR_do_token if provided
provider "digitalocean" {
  # If do_token is provided via TF_VAR_do_token, use it; otherwise provider will automatically use DIGITALOCEAN_TOKEN
  token = var.do_token
}

# Get the personal project
data "digitalocean_project" "personal" {
  name = "personal"
}

# Create a VPC
resource "digitalocean_vpc" "web_vpc" {
  name     = "simple-http-vpc"
  region   = "blr1"
  ip_range = "10.10.10.0/24"
}

# Create a new Droplet
resource "digitalocean_droplet" "server_droplet" {
  name     = "go-server"
  # size     = "s-2vcpu-4gb"  # 4GB RAM, 2 CPUs, 80GB NVMe SSD
  size = "c-4"
  image    = "ubuntu-22-04-x64"
  region   = "blr1"  # Bangalore 1 region
  vpc_uuid = digitalocean_vpc.web_vpc.id
  
  # Enable monitoring
  monitoring = true
  
  # SSH keys from environment variable
  ssh_keys = var.ssh_key_ids
  
  # User data script to set up the environment
  user_data = file("${path.module}/scripts/server.sh")
}

resource "digitalocean_droplet" "test_droplet" {
  name     = "test-server"
  size     = "s-2vcpu-4gb"  # 4GB RAM, 2 CPUs, 80GB NVMe SSD
  image    = "ubuntu-22-04-x64"
  region   = "blr1"  # Bangalore 1 region
  vpc_uuid = digitalocean_vpc.web_vpc.id
  
  # Enable monitoring
  monitoring = true
  
  # SSH keys from environment variable
  ssh_keys = var.ssh_key_ids
  
  # User data script to set up the environment
  user_data = file("${path.module}/scripts/test.sh")
}

# Output the droplet IP
output "server_ip" {
  value = digitalocean_droplet.server_droplet.ipv4_address
}

output "server_ip_private" {
  value = digitalocean_droplet.server_droplet.ipv4_address_private
}

output "test_ip" {
  value = digitalocean_droplet.test_droplet.ipv4_address
}

output "test_ip_private" {
  value = digitalocean_droplet.test_droplet.ipv4_address_private
}

# Assign resources to personal project
resource "digitalocean_project_resources" "project_resources" {
  project = data.digitalocean_project.personal.id
  resources = [
    digitalocean_droplet.server_droplet.urn,
    digitalocean_droplet.test_droplet.urn,
    # digitalocean_vpc.web_vpc.urn
  ]
}

