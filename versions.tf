
######
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
######
terraform {
  required_version = ">= 1.0"
  required_providers {
    google      = "~> 3.0"
    google-beta = ">= 3.20"
    random      = "~> 2.2"
  }
}
