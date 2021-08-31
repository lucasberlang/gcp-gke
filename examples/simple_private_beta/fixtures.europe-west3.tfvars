
description = "GKE Test Network"

ip_range_pods = "192.168.0.0/18"

ip_range_services = "192.168.64.0/18"

istio = false

dns_cache = false

labels = {
  "region"             = "euw3",
  "company"            = "bk",
  "account"            = "poc",
  "project_or_service" = "terraform",
  "application"        = "",
  "resource_type"      = "",
  "resource_name"      = "",
  "environment"        = "epd",
  "responsible"        = "",
  "confidentiality"    = "false",
  "encryption"         = "false",
  "os"                 = "",
  "role"               = "",
  "cmdb_id"            = "",
  "cmdb_name"          = "",
}
