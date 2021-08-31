# GCP GKE Terraform Module

Terraform module which creates a kubernetes engine on GCP.

Inspired by and adapted from [this](https://registry.terraform.io/modules/terraform-google-modules/kubernetes-engine)
and its [source code](https://github.com/terraform-google-modules/terraform-google-kubernetes-engine).

* [GCP Container Cluster](https://www.terraform.io/docs/providers/google/r/container_cluster.html)
* [GCP Container Node Pool](https://www.terraform.io/docs/providers/google/r/container_node_pool.html)

## Terraform versions

Only Terraform 0.14 is supported.

## Usage

```hcl
module "gke" {
  source = "git::ssh://git@vliamd634.cloud.bankia.int:7999/ter/gcp-gke.git?ref=v0.1.0"

  [...]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| google | ~> 3.0 |
| google-beta | >= 3.20 |
| random | ~> 2.2 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.0 |
| google-beta | >= 3.20 |
| random | ~> 2.2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| basic\_auth\_password | The password to be used with Basic Authentication | `string` | `""` | no |
| basic\_auth\_username | The username to be used with Basic Authentication | `string` | `""` | no |
| cluster\_autoscaling | The cluster autoscaling configuration | <pre>object({<br>    enabled             = bool<br>    autoscaling_profile = string<br>    min_cpu_cores       = number<br>    max_cpu_cores       = number<br>    min_memory_gb       = number<br>    max_memory_gb       = number<br>  })</pre> | <pre>{<br>  "autoscaling_profile": "BALANCED",<br>  "enabled": false,<br>  "max_cpu_cores": 0,<br>  "max_memory_gb": 0,<br>  "min_cpu_cores": 0,<br>  "min_memory_gb": 0<br>}</pre> | no |
| cluster\_ipv4\_cidr | The IP address range of the kubernetes pods in the cluster | `string` | `null` | no |
| create\_service\_account | Create additional service account | `bool` | `true` | no |
| database\_encryption | Application layer secrets encryption settings | <pre>list(<br>    object({<br>      state    = string,<br>      key_name = string<br>    })<br>  )</pre> | <pre>[<br>  {<br>    "key_name": "",<br>    "state": "DECRYPTED"<br>  }<br>]</pre> | no |
| default\_max\_pods\_per\_node | The maximum number of pods to schedule per node | `number` | `110` | no |
| description | The description of the cluster | `string` | `""` | no |
| dns\_cache | Should be true to enable NodeLocal DNSCache | `bool` | `false` | no |
| enable\_binary\_authorization | Should be true to enable Google Binary Authorization | `bool` | `false` | no |
| enable\_intranode\_visibility | Should be true to enable intra-node visibility | `bool` | `false` | no |
| enable\_kubernetes\_alpha | Should be true to enable Kubernetes alpha features | `bool` | `false` | no |
| enable\_network\_egress\_export | Should be true to enable network egress metering | `bool` | `false` | no |
| enable\_pod\_security\_policy | Should be true to enable PodSecurityPolicy | `bool` | `false` | no |
| enable\_private\_endpoint | Should be true to indicate whether the master's internal IP address is used as the cluster endpoint | `bool` | `false` | no |
| enable\_private\_nodes | Should be true to indicate that nodes have internal IP addresses only | `bool` | `false` | no |
| enable\_resource\_consumption\_export | Should be true to enable resource consumption metering | `bool` | `true` | no |
| enable\_shielded\_nodes | Should be true to enable shielded nodes features on all nodes | `bool` | `true` | no |
| enable\_tpu | Should be true to enable Cloud TPU resources | `bool` | `true` | no |
| enable\_vertical\_pod\_autoscaling | Should be true to enable Vertical Pod Autoscaling automatically | `bool` | `false` | no |
| gce\_persistent\_disk\_csi\_driver | Should be true to enable the Google Compute Engine Persistent Disk | `bool` | `false` | no |
| grant\_registry\_access | Grants created cluster-specific service account storage.objectViewer role | `bool` | `false` | no |
| horizontal\_pod\_autoscaling | Should be true to enable horizontal pod autoscaling addon | `bool` | `true` | no |
| http\_load\_balancing | Should be true to enable http loadbalancer addon | `bool` | `true` | no |
| initial\_node\_count | The number of nodes to create in this cluster default node pool | `number` | `0` | no |
| ip\_range\_pods | The name of the secondary subnet ip range to use for pods | `string` | `""` | no |
| ip\_range\_services | The name of the secondary subnet range to use for services | `string` | `""` | no |
| issue\_client\_certificate | Should be true to issue a client certificate to authenticate to the cluster endpoint | `bool` | `false` | no |
| istio | Should be true to enable Istio | `bool` | `false` | no |
| istio\_auth | The authentication type between services in Istio | `string` | `"AUTH_MUTUAL_TLS"` | no |
| kubernetes\_version | The Kubernetes version of the masters nodes | `string` | `"latest"` | no |
| labels | A mapping of labels to assign to the GCE resource | `map(string)` | `{}` | no |
| logging\_service | The logging service that the cluster should write logs | `string` | `"logging.googleapis.com/kubernetes"` | no |
| maintenance\_end\_time | Time window specified for recurring maintenance operations in RFC3339 format | `string` | `""` | no |
| maintenance\_recurrence | Frequency of the recurring maintenance window in RFC5545 format | `string` | `""` | no |
| maintenance\_start\_time | Time window specified for daily or recurring maintenance operations in RFC3339 format | `string` | `"05:00"` | no |
| master\_authorized\_networks | List of master authorized networks | <pre>list(<br>    object({<br>      cidr_block   = string,<br>      display_name = string<br>    })<br>  )</pre> | `[]` | no |
| master\_ipv4\_cidr\_block | The IP range in CIDR notation to use for the hosted master network | `string` | `"10.0.0.0/28"` | no |
| monitoring\_service | The monitoring service that the cluster should write metrics | `string` | `"monitoring.googleapis.com/kubernetes"` | no |
| name | The name of the cluster | `string` | n/a | yes |
| network | The VPC network to host the cluster in | `string` | n/a | yes |
| network\_policy | Should be true to enable the network policy of the cluster | `bool` | `true` | no |
| network\_policy\_provider | The network policy provider | `string` | `"CALICO"` | no |
| network\_project\_id | The project ID to host the VPC | `string` | `null` | no |
| node\_metadata | Specifies how node metadata is exposed to the workload running on the node | `string` | `"UNSPECIFIED"` | no |
| node\_pools | List of maps containing node pools | `list(map(string))` | <pre>[<br>  {<br>    "name": "default-node-pool"<br>  }<br>]</pre> | no |
| node\_pools\_oauth\_scopes | Map of lists containing node oauth scopes by node-pool name | `map(list(string))` | <pre>{<br>  "all": [<br>    "https://www.googleapis.com/auth/cloud-platform"<br>  ],<br>  "default-node-pool": []<br>}</pre> | no |
| node\_pools\_taints | Map of lists containing node taints by node-pool name | `map(list(object({ key = string, value = string, effect = string })))` | <pre>{<br>  "all": [],<br>  "default-node-pool": []<br>}</pre> | no |
| project\_id | The project ID to host the cluster in | `string` | n/a | yes |
| region | The region to host the cluster in | `string` | `null` | no |
| regional | Should be true to indicate that is a regional cluster | `bool` | `true` | no |
| registry\_project\_id | The project holding the Google Container Registry | `string` | `null` | no |
| release\_channel | The release channel of the cluster | `string` | `"UNSPECIFIED"` | no |
| remove\_default\_node\_pool | Should be true to remove default node pool while setting up the cluster | `bool` | `true` | no |
| resource\_usage\_export\_dataset\_id | The ID of a BigQuery Dataset for using BigQuery as the destination of resource usage export | `string` | `""` | no |
| sandbox\_enabled | Should be true to enable GKE Sandbox for gVisor | `bool` | `false` | no |
| service\_account | The service account to run nodes as if not overridden | `string` | `""` | no |
| subnetwork | The subnetwork to host the cluster in | `string` | n/a | yes |
| zones | The zones to host the cluster in | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| ca\_certificate | The cluster CA certificate (base64 encoded) |
| endpoint | The IP address of this cluster's Kubernetes master |
| master\_version | The current version of the master in the cluster |
| name | The GKE identifier |
| svc\_account\_email | The e-mail address of the service account |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Test

### Environment

Since most automated tests written with Terratest can make potentially destructive changes in your environment, we
strongly recommend running tests in an environment that is totally separate from production. For example, if you are
testing infrastructure code for GCP, you should run your tests in a completely separate GCP account.

### Requirements

Terratest uses the Go testing framework. To use terratest, you need to install:

* [Go](https://golang.org/) (requires version >=1.13)

### Running

Now you should be able to run the example test.

1. Change your working directory to the `test/src` folder.
1. Each time you want to run the tests:

```bash
go test -timeout 20m
```

### Terraform CLI

On the `examples/dummy` folder, perform the following commands.

* Get the plugins:

```bash
terraform init
```

* Review and apply the infrastructure test build:

```bash
terraform apply -var-file=fixtures.eu-west-1.tfvars
```

* Remove all resources:

```bash
terraform destroy -auto-approve
```
