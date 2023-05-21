
data "google_compute_zones" "available" {
  provider = google-beta

  project = var.project_id
  region  = local.region
}

resource "random_shuffle" "zones" {
  input        = data.google_compute_zones.available.names
  result_count = 3
}

locals {
  location       = var.regional ? var.region : var.zones[0]
  region         = var.regional ? var.region : join("-", slice(split("-", var.zones[0]), 0, 2))
  node_locations = var.regional ? coalescelist(compact(var.zones), sort(random_shuffle.zones.result)) : slice(var.zones, 1, length(var.zones))

  network_project_id = var.network_project_id != null ? var.network_project_id : var.project_id
}

resource "google_container_cluster" "this" {
  provider = google-beta

  name            = format("${local.prefix}${var.name}-gke%.2d-${var.labels.environment}", var.offset)
  description     = var.description
  project         = var.project_id
  resource_labels = var.labels

  location          = local.location
  node_locations    = local.node_locations
  cluster_ipv4_cidr = var.cluster_ipv4_cidr
  network           = "projects/${local.network_project_id}/global/networks/${var.network}"

  dynamic "network_policy" {
    for_each = local.cluster_network_policy

    content {
      enabled  = network_policy.value.enabled
      provider = network_policy.value.provider
    }
  }

  subnetwork = "projects/${local.network_project_id}/regions/${var.region}/subnetworks/${var.subnetwork}"

  min_master_version = var.release_channel != "UNSPECIFIED" ? null : var.kubernetes_version

  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  cluster_autoscaling {
    enabled             = var.cluster_autoscaling.enabled
    autoscaling_profile = var.cluster_autoscaling.autoscaling_profile != null ? var.cluster_autoscaling.autoscaling_profile : "BALANCED"
    dynamic "resource_limits" {
      for_each = local.autoscalling_resource_limits
      content {
        resource_type = lookup(resource_limits.value, "resource_type")
        minimum       = lookup(resource_limits.value, "minimum")
        maximum       = lookup(resource_limits.value, "maximum")
      }
    }
  }

  default_max_pods_per_node = var.default_max_pods_per_node

  enable_binary_authorization = var.enable_binary_authorization
  enable_intranode_visibility = var.enable_intranode_visibility
  enable_shielded_nodes       = var.enable_shielded_nodes
  enable_kubernetes_alpha     = var.enable_kubernetes_alpha
  enable_tpu                  = var.enable_tpu

  workload_identity_config {
    workload_pool = var.workload_identity == true ? "${var.project_id}.svc.id.goog" : null
  }

  release_channel {
    channel = var.release_channel
  }

  pod_security_policy_config {
    enabled = var.enable_pod_security_policy
  }

  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = var.issue_client_certificate
    }
  }

  addons_config {
    http_load_balancing {
      disabled = !var.http_load_balancing
    }

    horizontal_pod_autoscaling {
      disabled = !var.horizontal_pod_autoscaling
    }

    network_policy_config {
      disabled = !var.network_policy
    }

    istio_config {
      disabled = !var.istio
      auth     = var.istio_auth
    }

    dns_cache_config {
      enabled = var.dns_cache
    }

    gce_persistent_disk_csi_driver_config {
      enabled = var.gce_persistent_disk_csi_driver
    }
  }

  dynamic "ip_allocation_policy" {
    for_each = var.cluster_ipv4_cidr == null ? [{
      cluster_secondary_range_name  = var.ip_range_pods,
      services_secondary_range_name = var.ip_range_services
    }] : []

    content {
      cluster_secondary_range_name  = ip_allocation_policy.value.cluster_secondary_range_name
      services_secondary_range_name = ip_allocation_policy.value.services_secondary_range_name
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = local.master_authorized_networks_config
    content {
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value.cidr_blocks
        content {
          cidr_block   = lookup(cidr_blocks.value, "cidr_block", "")
          display_name = lookup(cidr_blocks.value, "display_name", "")
        }
      }
    }
  }

  maintenance_policy {
    dynamic "recurring_window" {
      for_each = local.cluster_maintenance_window_is_recurring
      content {
        start_time = var.maintenance_start_time
        end_time   = var.maintenance_end_time
        recurrence = var.maintenance_recurrence
      }
    }

    dynamic "daily_maintenance_window" {
      for_each = local.cluster_maintenance_window_is_daily
      content {
        start_time = var.maintenance_start_time
      }
    }
  }

  lifecycle {
    ignore_changes = [node_pool, initial_node_count]
  }

  node_pool {
    name               = "default-pool"
    initial_node_count = var.initial_node_count

    node_config {
      service_account = lookup(var.node_pools[0], "service_account", local.service_account)
      workload_metadata_config {
        mode = var.mode_metadata
      }
    }
  }

  dynamic "resource_usage_export_config" {
    for_each = var.resource_usage_export_dataset_id != "" ? [{
      enable_network_egress_metering       = var.enable_network_egress_export
      enable_resource_consumption_metering = var.enable_resource_consumption_export
      dataset_id                           = var.resource_usage_export_dataset_id
    }] : []

    content {
      enable_network_egress_metering       = resource_usage_export_config.value.enable_network_egress_metering
      enable_resource_consumption_metering = resource_usage_export_config.value.enable_resource_consumption_metering
      bigquery_destination {
        dataset_id = resource_usage_export_config.value.dataset_id
      }
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.enable_private_nodes ? [{
      enable_private_nodes    = var.enable_private_nodes,
      enable_private_endpoint = var.enable_private_endpoint
      master_ipv4_cidr_block  = var.master_ipv4_cidr_block
    }] : []

    content {
      enable_private_endpoint = private_cluster_config.value.enable_private_endpoint
      enable_private_nodes    = private_cluster_config.value.enable_private_nodes
      master_ipv4_cidr_block  = private_cluster_config.value.master_ipv4_cidr_block
    }
  }

  remove_default_node_pool = var.remove_default_node_pool

  dynamic "database_encryption" {
    for_each = var.database_encryption

    content {
      key_name = database_encryption.value.key_name
      state    = database_encryption.value.state
    }
  }

}

resource "google_container_node_pool" "pools" {
  provider = google-beta

  for_each       = local.node_pools
  cluster        = google_container_cluster.this.name
  node_locations = local.node_locations
  name           = each.key

  location = local.location
  project  = var.project_id

  version = lookup(each.value, "auto_upgrade", false) ? "" : lookup(
    each.value,
    "version",
    google_container_cluster.this.min_master_version,
  )

  initial_node_count = lookup(each.value, "autoscaling", true) ? lookup(
    each.value,
    "initial_node_count",
    lookup(each.value, "min_count", 1)
  ) : null

  max_pods_per_node = lookup(each.value, "max_pods_per_node", null)

  node_count = lookup(each.value, "autoscaling", true) ? null : lookup(each.value, "node_count", 1)

  dynamic "autoscaling" {
    for_each = lookup(each.value, "autoscaling", true) ? [each.value] : []
    content {
      min_node_count = lookup(autoscaling.value, "min_count", 1)
      max_node_count = lookup(autoscaling.value, "max_count", 10)
    }
  }

  management {
    auto_repair  = lookup(each.value, "auto_repair", true)
    auto_upgrade = lookup(each.value, "auto_upgrade", true)
  }

  upgrade_settings {
    max_surge       = lookup(each.value, "max_surge", 1)
    max_unavailable = lookup(each.value, "max_unavailable", 0)
  }

  node_config {
    image_type   = lookup(each.value, "image_type", "COS_CONTAINERD")
    machine_type = lookup(each.value, "machine_type", "n1-standard-2")
    labels       = var.node_labels

    dynamic "taint" {
      for_each = concat(
        var.node_pools_taints["all"],
        var.node_pools_taints[each.value["name"]],
      )
      content {
        effect = taint.value.effect
        key    = taint.value.key
        value  = taint.value.value
      }
    }

    tags = ["private"]

    disk_size_gb = lookup(each.value, "disk_size_gb", 30)
    disk_type    = lookup(each.value, "disk_type", "pd-standard")
    preemptible  = lookup(each.value, "preemptible", false)

    service_account = lookup(
      each.value,
      "service_account",
      local.service_account,
    )

    oauth_scopes = concat(
      var.node_pools_oauth_scopes["all"],
      var.node_pools_oauth_scopes[each.value["name"]],
    )

    guest_accelerator = [
      for guest_accelerator in lookup(each.value, "accelerator_count", 0) > 0 ? [{
        type  = lookup(each.value, "accelerator_type", "")
        count = lookup(each.value, "accelerator_count", 0)
        }] : [] : {
        type  = guest_accelerator["type"]
        count = guest_accelerator["count"]
      }
    ]

    dynamic "sandbox_config" {
      for_each = local.cluster_sandbox_enabled

      content {
        sandbox_type = sandbox_config.value
      }
    }

    boot_disk_kms_key = lookup(each.value, "boot_disk_kms_key", "")

    shielded_instance_config {
      enable_secure_boot          = lookup(each.value, "enable_secure_boot", false)
      enable_integrity_monitoring = lookup(each.value, "enable_integrity_monitoring", true)
    }
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
