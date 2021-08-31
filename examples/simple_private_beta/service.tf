
data "google_client_config" "default" {
  provider = google-beta
}

provider "kubernetes" {
  load_config_file       = false
  host                   = module.gke.endpoint
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "web"
    namespace = "default"
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        run = "web"
      }
    }
    template {
      metadata {
        labels = {
          run = "web"
        }
      }
      spec {
        container {
          image             = "gcr.io/google-samples/hello-app:1.0"
          image_pull_policy = "IfNotPresent"
          name              = "web"

          port {
            container_port = 8080
          }

          readiness_probe {
            http_get {
              path   = "/"
              port   = 8080
              scheme = "HTTP"
            }

            initial_delay_seconds = 30
            timeout_seconds       = 5
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "web"
    namespace = "default"
  }

  spec {
    selector = {
      run = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.run
    }
    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}

resource "kubernetes_ingress" "example_ingress" {
  metadata {
    name = "basic-ingress"
  }

  spec {
    backend {
      service_name = "web"
      service_port = 80
    }

  }
}
