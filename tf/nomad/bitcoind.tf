resource "nomad_quota_specification" "bitcoin-node" {
  name        = "bitcoin-node"
  description = "resource quota for bitcoin-node namespace"

  limits {
    region = "global"

    region_limit {
      cpu       = 1000
      memory_mb = 256
    }
  }
}

resource "nomad_namespace" "bitcoin-node" {
  name        = "bitcoin-node"
  description = "bitcoin-node namespace"
  quota       = nomad_quota_specification.bitcoin-node.name
}

resource "nomad_sentinel_policy" "docker-only" {
  name        = "docker-only"
  description = "Only allow jobs that are based on an docker driver."

  policy = <<EOT
main = rule { all_drivers_docker }

# all_drivers_docker checks that all the drivers in use are docker
all_drivers_docker = rule {
    all job.task_groups as tg {
        all tg.tasks as task {
            task.driver is "docker"
        }
    }
}
EOT

  scope = "submit-job"

  # allow administrators to override
  enforcement_level = "soft-mandatory"
}

# not sure if it makes sense to have jobs in terraform. k8s jobs are now preferred outside a terraform repo in their own one managed by argo/flux
resource "nomad_job" "app" {
  jobspec = file("${path.module}/tf/nomad/bitcoind.nomad.hcl")
}