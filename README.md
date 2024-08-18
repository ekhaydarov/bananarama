# bananarama

[verify bitcoin binary](https://github.com/bitcoin/bitcoin/blob/master/contrib/verify-binaries/README.md)

[image scanning with trivy](https://aquasecurity.github.io/trivy/v0.17.2/installation/)

no bitcoin.conf use default

## K8s
previously deployed namecoin in kubernetes so lifting a bit of code from my [own previous work](https://github.com/ekhaydarov/home-k8s/tree/master/home/nmc/templates)
adding a bit more security constraints and resources

## CI/CD
the deployment and verification of resources is performed by third party tools such as ArgoCD or FluxCD

## logparser
### bash
since we only after ip and nothing else we dont need regex. test run with 
```bash
make logparser-sh
```
### python
same tactic can be employed for python and we dont need regex
```bash
make logparser-py
```

## TF IAM roles
Call the module with the following 
```
module "iam" {
  source = "./tf/modules/aws_iam"

  role_name        = "assumable-role"
  policy_name      = "allow-assume-role-policy"
  group_name       = "assume-role-group"
  user_names        = [
    "assume-role-user",
    "assume-role-user2"
  ]
}
```

## nomad deployment
example docs on nomad [here](https://github.com/hashicorp/nomad-guides/tree/master/application-deployment/microservices)
cannot test sentinel due to error
```bash
nomad sentinel apply -level=advisory test-policy test.sentinel
Error writing Sentinel policy: Unexpected response code: 501 (Nomad Enterprise only endpoint)
```

Seems like you need to manually apply nomad client policy, no mention of it in nomad [tf provider ](https://registry.terraform.io/providers/hashicorp/nomad/latest/docs)
```bash
nomad agent -config=server.conf
```

Prerequisites are to install and run a dev nomad server. manually update agents and then you can use terraform to plan and apply nomad jobs.
```bash
make nomad-agent-config
make nomad-deploy
```
