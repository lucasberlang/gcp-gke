
######
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# This module has been updated with 0.12 syntax, which means it is no longer compatible with any versions below 0.12.
######
terraform {
  required_version = ">= 1.0"
  required_providers {
    google      = "~> 4.0"
    google-beta = "~> 4.0"
    random      = "~> 2.2"
  }
}
