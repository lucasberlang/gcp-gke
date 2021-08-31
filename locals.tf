
locals {
  prefix = join("-", tolist(["go", lower(var.labels.region), var.labels.company, var.labels.account, ""]))

  cluster_network_policy = var.network_policy ? [{
    enabled  = true
    provider = var.network_policy_provider
    }] : [{
    enabled  = false
    provider = null
  }]

  autoscalling_resource_limits = var.cluster_autoscaling.enabled ? [{
    resource_type = "cpu"
    minimum       = var.cluster_autoscaling.min_cpu_cores
    maximum       = var.cluster_autoscaling.max_cpu_cores
    }, {
    resource_type = "memory"
    minimum       = var.cluster_autoscaling.min_memory_gb
    maximum       = var.cluster_autoscaling.max_memory_gb
  }] : []

  cluster_maintenance_window_is_recurring = var.maintenance_recurrence != "" && var.maintenance_end_time != "" ? [1] : []
  cluster_maintenance_window_is_daily     = length(local.cluster_maintenance_window_is_recurring) > 0 ? [] : [1]

  node_pool_names = [for np in toset(var.node_pools) : np.name]
  node_pools      = zipmap(local.node_pool_names, tolist(toset(var.node_pools)))

  cluster_sandbox_enabled = var.sandbox_enabled ? ["gvisor"] : []

  master_authorized_networks_config = length(var.master_authorized_networks) == 0 ? [] : [{
    cidr_blocks : var.master_authorized_networks
  }]

  cluster_master_auth_list_layer1 = concat(google_container_cluster.this.*.master_auth, [])
  cluster_master_auth_list_layer2 = local.cluster_master_auth_list_layer1[0]
  cluster_master_auth_map         = local.cluster_master_auth_list_layer2[0]
  cluster_ca_certificate          = local.cluster_master_auth_map["cluster_ca_certificate"]
}
