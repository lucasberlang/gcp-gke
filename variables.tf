
######
# google_container_cluster
######

variable "regional" {
  description = "Should be true to indicate that is a regional cluster"
  type        = bool
  default     = true
}

variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "name" {
  description = "The name of the cluster"
  type        = string
}

variable "offset" {
  description = "The offset to be added to the GKE counter"
  type        = number
  default     = 1
}

variable "description" {
  description = "The description of the cluster"
  type        = string
  default     = ""
}

variable "region" {
  description = "The region to host the cluster in"
  type        = string
  default     = null
}

variable "zones" {
  description = "The zones to host the cluster in"
  type        = list(string)
  default     = []
}

variable "cluster_ipv4_cidr" {
  description = "The IP address range of the kubernetes pods in the cluster"
  type        = string
  default     = null
}

variable "network_project_id" {
  description = "The project ID to host the VPC"
  type        = string
  default     = null
}

variable "network" {
  description = "The VPC network to host the cluster in"
  type        = string
}

variable "subnetwork" {
  description = "The subnetwork to host the cluster in"
  type        = string
}

variable "network_policy" {
  description = "Should be true to enable the network policy of the cluster"
  type        = bool
  default     = true
}

variable "network_policy_provider" {
  description = "The network policy provider"
  type        = string
  default     = "CALICO"
}

variable "release_channel" {
  description = "The release channel of the cluster"
  type        = string
  default     = "UNSPECIFIED"
}

variable "kubernetes_version" {
  description = "The Kubernetes version of the masters nodes"
  type        = string
  default     = "latest"
}

variable "logging_service" {
  description = "The logging service that the cluster should write logs"
  type        = string
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  description = "The monitoring service that the cluster should write metrics"
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "cluster_autoscaling" {
  description = "The cluster autoscaling configuration"
  type = object({
    enabled             = bool
    autoscaling_profile = string
    min_cpu_cores       = number
    max_cpu_cores       = number
    min_memory_gb       = number
    max_memory_gb       = number
  })
  default = {
    enabled             = false
    autoscaling_profile = "BALANCED"
    max_cpu_cores       = 0
    min_cpu_cores       = 0
    max_memory_gb       = 0
    min_memory_gb       = 0
  }
}

variable "default_max_pods_per_node" {
  description = "The maximum number of pods to schedule per node"
  type        = number
  default     = 110
}

variable "enable_binary_authorization" {
  description = "Should be true to enable Google Binary Authorization"
  type        = bool
  default     = false
}

variable "enable_intranode_visibility" {
  description = "Should be true to enable intra-node visibility"
  type        = bool
  default     = false
}

variable "workload_identity" {
  description = "Workload Identity allows Kubernetes service accounts to act as a user-managed Google IAM Service Account."
  type        = bool
  default     = false
}

variable "enable_kubernetes_alpha" {
  description = "Should be true to enable Kubernetes alpha features"
  type        = bool
  default     = false
}

variable "enable_shielded_nodes" {
  description = "Should be true to enable shielded nodes features on all nodes"
  type        = bool
  default     = true
}

variable "enable_tpu" {
  description = "Should be true to enable Cloud TPU resources"
  type        = bool
  default     = true
}

variable "enable_vertical_pod_autoscaling" {
  description = "Should be true to enable Vertical Pod Autoscaling automatically"
  type        = bool
  default     = false
}

variable "enable_pod_security_policy" {
  description = "Should be true to enable PodSecurityPolicy"
  type        = bool
  default     = false
}

variable "issue_client_certificate" {
  description = "Should be true to issue a client certificate to authenticate to the cluster endpoint"
  type        = bool
  default     = false
}

variable "http_load_balancing" {
  description = "Should be true to enable http loadbalancer addon"
  type        = bool
  default     = true
}

variable "horizontal_pod_autoscaling" {
  description = "Should be true to enable horizontal pod autoscaling addon"
  type        = bool
  default     = true
}

variable "istio" {
  description = "Should be true to enable Istio"
  type        = bool
  default     = false
}

variable "istio_auth" {
  description = "The authentication type between services in Istio"
  type        = string
  default     = "AUTH_MUTUAL_TLS"
}

variable "dns_cache" {
  description = "Should be true to enable NodeLocal DNSCache"
  type        = bool
  default     = false
}

variable "gce_persistent_disk_csi_driver" {
  description = "Should be true to enable the Google Compute Engine Persistent Disk"
  type        = bool
  default     = false
}

variable "ip_range_pods" {
  description = "The name of the secondary subnet ip range to use for pods"
  type        = string
  default     = ""
}

variable "ip_range_services" {
  description = "The name of the secondary subnet range to use for services"
  type        = string
  default     = ""
}

variable "master_authorized_networks" {
  description = "List of master authorized networks"
  type = list(
    object({
      cidr_block   = string,
      display_name = string
    })
  )
  default = []
}

variable "maintenance_start_time" {
  description = "Time window specified for daily or recurring maintenance operations in RFC3339 format"
  type        = string
  default     = "05:00"
}

variable "maintenance_end_time" {
  description = "Time window specified for recurring maintenance operations in RFC3339 format"
  type        = string
  default     = ""
}

variable "maintenance_recurrence" {
  description = "Frequency of the recurring maintenance window in RFC5545 format"
  type        = string
  default     = ""
}

variable "mode_metadata" {
  description = "Specifies how node metadata is exposed to the workload running on the node"
  type        = string
  default     = "MODE_UNSPECIFIED"
}

variable "initial_node_count" {
  description = "The number of nodes to create in this cluster default node pool"
  type        = number
  default     = 0
}

variable "resource_usage_export_dataset_id" {
  description = "The ID of a BigQuery Dataset for using BigQuery as the destination of resource usage export"
  type        = string
  default     = ""
}

variable "enable_network_egress_export" {
  description = "Should be true to enable network egress metering"
  type        = bool
  default     = false
}

variable "enable_resource_consumption_export" {
  description = "Should be true to enable resource consumption metering"
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Should be true to indicate whether the master's internal IP address is used as the cluster endpoint"
  type        = bool
  default     = false
}

variable "enable_private_nodes" {
  description = "Should be true to indicate that nodes have internal IP addresses only"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "The IP range in CIDR notation to use for the hosted master network"
  type        = string
  default     = "10.0.0.0/28"
}

variable "remove_default_node_pool" {
  description = "Should be true to remove default node pool while setting up the cluster"
  type        = bool
  default     = true
}

variable "database_encryption" {
  description = "Application layer secrets encryption settings"
  type = list(
    object({
      state    = string,
      key_name = string
    })
  )
  default = [{
    state    = "DECRYPTED"
    key_name = ""
  }]
}

variable "dns_config" {
  description = "Configuration for Using Cloud DNS for GKE"
  type = list(
    object({
      cluster_dns       = string,
      cluster_dns_scope = string
    })
  )
  default = []
}

######
# google_container_node_pool
######

variable "node_pools" {
  type        = list(map(string))
  description = "List of maps containing node pools"

  default = [
    {
      name = "default-node-pool"
    },
  ]
}

variable "node_pools_taints" {
  type        = map(list(object({ key = string, value = string, effect = string })))
  description = "Map of lists containing node taints by node-pool name"

  default = {
    all               = []
    default-node-pool = []
  }
}

variable "node_pools_oauth_scopes" {
  type        = map(list(string))
  description = "Map of lists containing node oauth scopes by node-pool name"

  default = {
    all               = ["https://www.googleapis.com/auth/cloud-platform"]
    default-node-pool = []
  }
}

variable "sandbox_enabled" {
  description = "Should be true to enable GKE Sandbox for gVisor"
  type        = bool
  default     = false
}

######
# google_service_account
######

variable "create_service_account" {
  description = "Create additional service account"
  type        = bool
  default     = true
}

variable "grant_registry_access" {
  description = "Grants created cluster-specific service account storage.objectViewer role"
  type        = bool
  default     = false
}

variable "registry_project_id" {
  description = "The project holding the Google Container Registry"
  type        = string
  default     = null
}

variable "service_account" {
  type        = string
  description = "The service account to run nodes as if not overridden"
  default     = ""
}

######
# Tags
######

variable "labels" {
  description = "A mapping of labels to assign to the GCE resource"
  type        = map(string)
  default     = {}
}
