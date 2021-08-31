
provider "google" {
  region = var.region
}

provider "google-beta" {
  region = var.region
}

module "network" {
  source = "../../../gcp-network"

  project_id         = var.project_id
  description        = var.description
  enable_nat_gateway = true

  intra_subnets = [
    {
      subnet_name           = "private-subnet01"
      subnet_ip_cidr        = "10.128.0.0/16"
      subnet_private_access = true
      subnet_region         = var.region
    }
  ]

  labels = var.labels
}

module "gke" {
  source = "../../"

  project_id = var.project_id
  name       = "classic"
  regional   = true
  region     = var.region
  network    = module.network.network_name
  subnetwork = module.network.intra_subnet_names.0

  default_max_pods_per_node = null
  enable_tpu                = false

  enable_private_endpoint = false
  enable_private_nodes    = false
  cluster_ipv4_cidr       = "10.96.0.0/16"
  release_channel         = "STABLE"

  master_authorized_networks = [
    {
      cidr_block   = module.network.intra_subnet_ips.0
      display_name = "VPC"
    },
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "shell"
    }
  ]

  istio     = var.istio
  dns_cache = var.dns_cache
  labels    = var.labels
}
