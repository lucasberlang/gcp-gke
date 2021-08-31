
######
# google_container_cluster
######

output "ca_certificate" {
  sensitive   = true
  description = "The cluster CA certificate (base64 encoded)"
  value       = local.cluster_ca_certificate
}

output "endpoint" {
  sensitive   = true
  description = "The IP address of this cluster's Kubernetes master"
  value       = "https://${google_container_cluster.this.endpoint}"
  depends_on = [
    google_container_cluster.this,
    google_container_node_pool.pools
  ]
}

output "svc_account_email" {
  description = "The e-mail address of the service account"
  value       = local.service_account
}

output "name" {
  description = "The GKE identifier"
  value       = google_container_cluster.this.name
}

output "master_version" {
  description = "The current version of the master in the cluster"
  value       = google_container_cluster.this.master_version
}
