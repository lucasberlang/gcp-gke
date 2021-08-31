
locals {
  create_service_account = (var.service_account == "" && var.create_service_account) ? true : false

  all_service_account_roles = local.create_service_account ? [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ] : []

  service_account_list = compact(
    concat(
      google_service_account.cluster_service_account.*.email,
      ["dummy"],
    ),
  )

  service_account = local.create_service_account ? local.service_account_list[0] : var.service_account

  registry_project_id = var.registry_project_id == null ? var.project_id : var.registry_project_id
}

resource "random_string" "suffix" {
  upper   = false
  lower   = true
  special = false
  length  = 4
}

resource "google_service_account" "cluster_service_account" {
  count = local.create_service_account ? 1 : 0

  project     = var.project_id
  account_id  = "${local.prefix}gke-sa${random_string.suffix.result}-${var.labels.environment}"
  description = "Terraform managed service account for cluster gke"
}

resource "google_project_iam_member" "service_account_roles" {
  for_each = toset(local.all_service_account_roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}

resource "google_project_iam_member" "gcr" {
  count = local.create_service_account && var.grant_registry_access ? 1 : 0

  project = local.registry_project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.cluster_service_account[0].email}"
}
