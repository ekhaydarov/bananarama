# bananarama

[verify bitcoin binary](https://github.com/bitcoin/bitcoin/blob/master/contrib/verify-binaries/README.md)
[image scanning with trivy](https://aquasecurity.github.io/trivy/v0.17.2/installation/)
no bitcoin conf use default

## K8s
previously deployed namecoin in kubernetes so lifting a bit of code from my [own previous work](https://github.com/ekhaydarov/home-k8s/tree/master/home/nmc/templates)
adding a bit more security constraints and resources

## CI/CD
the deployment and verification of resources is performed by third party tools such as ArgoCD or FluxCD