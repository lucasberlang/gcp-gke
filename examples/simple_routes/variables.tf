
variable "project_id" {
  description = "fixture"
  type        = string
  default     = "practica-cloud-286009"
}

variable "region" {
  description = "fixture"
  type        = string
  default     = "europe-west3"
}

######
# Vars
######

variable "description" {
  description = "fixture"
  type        = string
}

variable "istio" {
  description = "fixture"
  type        = bool
}

variable "dns_cache" {
  description = "fixture"
  type        = bool
}

######
# Tags
######

variable "labels" {
  description = "fixture"
  type        = map(string)
}
