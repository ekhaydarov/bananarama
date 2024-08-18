job "bitcoind" {
  datacenters = ["dc1"]
  type        = "service"
  namespace   = "bitcoin-node"

  # current docker image is linux only, however, seems to not work in current set up
  // constraint {
  //   attribute = "${attr.kernel.name}"
  //   value = "linux"
  // } 

  group "node" {
    count = 1

    scaling {
      enabled = true
      min     = 1
      max     = 40
    }

    restart {
      attempts = 3
      interval = "5m"
      delay = "25s"
      mode = "delay"
    }

    # mount external volume to provide space for bitcoin blockchain download, need to provide cloud csi storage with around 1TB
    // volume "data" {
    //   type            = "csi"
    //   source          = "csi-volume"
    //   read_only       = true
    //   attachment_mode = "file-system"
    //   access_mode     = "single-node-writer"
    //   per_alloc       = true

    //   mount_options {
    //     fs_type     = "ext4"
    //   }
    // }

    network {
      port "http" {
        static = 8332
      }
    }

    task "server" {
      driver = "docker"

      env {
        ENVIRONMENT = "dev"
      }

      config {
        image = "erikpack/bitcoind:26.2"
        ports = ["http"]

        volumes = [
          "nomad/data:/.bitcoin"
        ]
      }

      resources {
        cpu    = 500
        memory = 256
        disk   = 8192 # test on my machine need to expand to handle the entire blockchain data
      }

      service {
        // name = "bitcoind" no need for name as the default is more explicit (string: "<job>-<taskgroup>-<task>")
        port     = "http"
        provider = "nomad" # otherwise you get errors like this https://github.com/hashicorp/waypoint/issues/3376

        check {
          name     = "http-check"
          type     = "http"
          path     = "/"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}