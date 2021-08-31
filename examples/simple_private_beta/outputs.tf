
output "dummy_name" {
  description = "The GKE identifier"
  value       = module.gke.name
}

output "dummy_master_version" {
  description = "The current version of the master in the cluster"
  value       = module.gke.master_version
}
