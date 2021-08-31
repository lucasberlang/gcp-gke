
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
      subnet_ip_cidr        = "10.0.0.0/16"
      subnet_private_access = true
      subnet_region         = var.region
    }
  ]

  secondary_ranges = {
    private-subnet01 = [
      {
        range_name    = "private-subnet01-01"
        ip_cidr_range = var.ip_range_pods
      },
      {
        range_name    = "private-subnet01-02"
        ip_cidr_range = var.ip_range_services
      },
    ]
  }

  labels = var.labels
}

module "gke" {
  source = "../../"

  project_id = var.project_id
  name       = "dummy"
  regional   = true
  region     = var.region
  network    = module.network.network_name
  subnetwork = module.network.intra_subnet_names.0

  ip_range_pods     = "private-subnet01-01"
  ip_range_services = "private-subnet01-02"

  enable_private_endpoint = false
  enable_private_nodes    = true
  master_ipv4_cidr_block  = "172.16.0.0/28"
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
