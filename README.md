# [Ortelius](https://ortelius.io/) local development environment

## What you need?
- Docker
- Kind
- Terraform

## K8s Ortelius cluster details
### Context `kind-ortelius`
- List all the contexts
```
kubectl config get context
```
- Switch to the kind-ortelius context
```
kubectl config use-context kind-ortelius
```
- Help with contexts
```
kubectl config -h
```
- Namespace `ortelius`
- List all namespaces
```
kubectl get namespace -A
```
### Nodes
- Control Plane `ortelius-control-plane`
- Worker `ortelius-worker`
```
kubectl get nodes -A
```

## [Docker.com](https://www.docker.com/)
### [GitHub](https://github.com/docker)

Docker is software that provides containers, which allows teams to emulate development environments.
Docker began as an internal project, initially developed by dotCloud engineers.

- [Account setup](https://hub.docker.com/signup)
- [Install](https://docs.docker.com/get-docker/)
- Get familiar with the basic commands
- Use [Devdocs](https://devdocs.io/) and the Docker documentation [here](https://docs.docker.com/)
- [Terms & Conditions](https://www.docker.com/legal/docker-terms-service/)

### Helpful commands
#### List images
```
docker container ls
```
#### Pull the current images to the local machine at the time of writing
```
docker pull quay.io/ortelius/ortelius:latest
```
```
docker pull ghcr.io/ortelius/keptn-ortelius-service:0.0.2-dev
```
```
docker image list | grep <add your desired filter>
```
#### Copy
```
docker cp ~/.docker/config.json ortelius-in-a-box-control-plane:/var/lib/kubelet/config.json
```
#### Exec
```
docker exec -it ortelius-in-a-box-worker bash
```
#### Delete images
```
docker image rm quay.io/ortelius/ortelius
```

## [Kind.sigs.k8s.io](https://kind.sigs.k8s.io/)
### [GitHub](https://github.com/kubernetes-sigs/kind)
kind is a tool for running local Kubernetes clusters using Docker container "nodes". kind was primarily designed for testing Kubernetes itself, but may be used for local development or CI.
- Install [here](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- Kind allows you to use Docker to run K8s nodes as containers
- Get familiar with the basic commands
- Checkout the Kind documentation [here](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [Terms & Conditions](https://www.apache.org/licenses/LICENSE-2.0)

### Why kind?
- kind supports multi-node (including HA) clusters
- kind supports building Kubernetes release builds from source
- support for make / bash or docker, in addition to pre-published builds
- kind supports Linux, macOS and Windows
- kind is a `CNCF certified conformant Kubernetes installer`

### Helpful commands
#### Get the list of nodes
```
kind get nodes -n ortelius-in-a-box
```
#### Cluster info
```
kubectl cluster-info --context ortelius-in-a-box
```
#### Logs
```
kind export logs -n ortelius-in-a-box
```
#### Load an image onto the container nodes
```
kind load docker-image --name ortelius-in-a-box --nodes ortelius-in-a-box-control-plane,ortelius-in-a-box-worker ghcr.io/ortelius/keptn-ortelius-service:0.0.2-dev
```

## [Container Runtime Interface (CRI) CLI](https://kubernetes.io/docs/tasks/debug/debug-cluster/crictl/)
### [GitHub](https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md)

crictl provides a CLI for CRI-compatible container runtimes. This allows the CRI runtime developers to debug their runtime without needing to set up Kubernetes components.
crictl is currently in Beta and still under quick iterations. It is hosted at the cri-tools repository. We encourage the CRI developers to report bugs or help extend the coverage by adding more functionalities.
- Download crictl [here](https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md)
#### using `wget`
```
VERSION="v1.24.1"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz
```
#### using `curl`
```
VERSION="v1.24.1"
curl -L https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-${VERSION}-linux-amd64.tar.gz --output crictl-${VERSION}-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz
```

## [Kubernetes.io](https://kubernetes.io/)

Kubernetes, also known as K8s, is an open-source system for automating deployment, scaling, and management of containerized applications.

### [GitHub](https://github.com/kubernetes-sigs)
- [Terms & Conditions](https://www.linuxfoundation.org/legal/terms#:~:text=Users%20are%20solely%20responsible%20for,arising%20out%20of%20User%20Content.)
- [Creative Commons](https://creativecommons.org/licenses/by/3.0/)
### Kubectl
- Install `kubectl` the command line tool [here](https://kubernetes.io/docs/tasks/tools/)
- Use the `kubectl` cheat sheet [here](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- Use [Devdocs](https://devdocs.io/) and the official documentation [here](https://kubernetes.io/docs/home/)
- Add the `aliases` & `auto complete` which are in the `cheat sheet`

### Helpful tools
### Combine Kubens & Kubectx with Fuzzy Finder
- `kubectx` is a tool to switch between contexts (clusters) on kubectl faster.
- `kubens` is a tool to switch between Kubernetes namespaces (and configure them for kubectl) easily.
- `fzf` is a general-purpose command-line fuzzy finder.
- `fzf` is an interactive Unix filter for command-line that can be used with any list; files, command history, processes, hostnames, bookmarks, git commits, etc.
- Download `Fuzzy Finder` [here](https://github.com/junegunn/fzf)
- Download `Kubens & Kubectx` [here](https://github.com/ahmetb/kubectx)
#### Kubectx for switching context
```
kubectx kind-ortelius-in-a-box
```
#### Kubens for switching namespaces
```
kubens argocd
```

## Octant | GUI of your K8s Clusters
### [GitHub](https://github.com/vmware-archive/octant)

Octant is a tool for developers to understand how applications run on a Kubernetes cluster. It aims to be part of the developer's toolkit for gaining insight and approaching complexity found in Kubernetes. Octant offers a combination of introspective tooling, cluster navigation, and object management along with a plugin system to further extend its capabilities.

- Download [here](https://github.com/vmware-tanzu/octant)
- Documentation [here](https://octant.dev/docs/)
- Supports dark mode
- Plugins [here](https://github.com/topics/octant-plugin)
### Notable Plugins
- [Helm](https://github.com/bloodorangeio/octant-helm)
- [Policy Report](https://github.com/evalsocket/policyreport-octant-plugin)

## [Terraform](https://www.terraform.io/intro)
### [GitHub](https://github.com/hashicorp/terraform)

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

- Install Terraform [here](https://www.terraform.io/downloads)
- Documentation is [here](https://www.terraform.io/docs)
- [Terms & Conditions](https://registry.terraform.io/terms)
### Deployment Benchmark Times for just the Kind Cluster & Ortelius deployment
#### Dell G15 5510
- Intel Core i5-10200H CPU @ 2.40GHZ
- 8 GB RAM
- SSD Disk
- Windows 10
- Benchmark time to deploy `10min`
#### Mac M1
- Apple Silicon CPU
- 16 GB RAM
- SSD Disk
- OSX Ventura
- Benchmark time to deploy `7min`
### Steps to get going
- Navigate to `/terraform`
- Run the following
```
terraform init
```
```
terraform plan
```
### Time the deployment
```
time terraform apply --auto-approve
```
`OR`
### No timing the deployment
```
terraform apply --auto-approve
```
### Logs
In total, there 5 log levels which can be used for debugging purposes:
- `TRACE` one of the most descriptive log levels, if you set the log level to *TRACE,* Terraform will write every action and step into the log file.
- `DEBUG` a little bit more sophisticated logging which is used by developers at critical or more complex pieces of code to reduce debugging time.
- `INFO` the info log level is useful when needing to log some informative instructions or readme type instructions.
- `WARN` used when something is not critical but would be nice to include in the form of a log so that the developer can make adjustments later.
- `ERROR` as the name suggests, this is used if something is terribly wrong and is a blocker.
```
export TF_LOG="DEBUG"
```
```
export TF_LOG_PATH="/abraham/terraform-debug.log"
```

## [Ingress Nginx Controller](https://kubernetes.github.io/ingress-nginx/)
### [GitHub](https://github.com/kubernetes/ingress-nginx/)

ingress-nginx is an Ingress controller for Kubernetes using NGINX as a reverse proxy and load balancer.
