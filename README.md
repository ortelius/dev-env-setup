### [Ortelius Issue 535](https://github.com/ortelius/ortelius/issues/535)

### Deployment Benchmark Times for just the Kind Cluster & Ortelius
```
time terraform apply
```
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

### [VSCode](https://code.visualstudio.com/) IDE
- Download `VSCode IDE` [here](https://code.visualstudio.com/download)
- Security starts in the IDE
- [Terms & Conditions](https://code.visualstudio.com/License/)

#### Helpful Extensions
- Install `Snyk Security | Code & Open Source Dependencies` scanner [here](https://marketplace.visualstudio.com/items?itemName=snyk-security.snyk-vulnerability-scanner)
- Install `Language Support for Java by Red Hat` [here](https://marketplace.visualstudio.com/items?itemName=redhat.java)
- Install `Yaml` support [here](https://marketplace.visualstudio.com/items?itemName=redhat.java)
- Install `Indent Rainbow` [here](https://marketplace.visualstudio.com/items?itemName=redhat.java)
- Install `Change All End of Line Sequence` [here](https://marketplace.visualstudio.com/items?itemName=vs-publisher-1448185.keyoti-changeallendoflinesequence)
- Install `ToDo Tree` [here](https://marketplace.visualstudio.com/items?itemName=Gruntfuggly.todo-tree)

### [Docker.com](https://www.docker.com/)
- [Account setup](https://hub.docker.com/signup)
- [Install](https://docs.docker.com/get-docker/)
- Get familiar with the basic commands
- Use [Devdocs](https://devdocs.io/) and the Docker documentation [here](https://docs.docker.com/)
- [Terms & Conditions](https://www.docker.com/legal/docker-terms-service/)

**Docker Security**
- Bake security right in from the word go
- We are going to use Snyk to scan our containers
- Snyk is free and you can set yourself up [here](https://snyk.io/)
- [Terms & Conditions for Snyk](https://snyk.io/policies/terms-of-service/)
- In `Docker Desktop` go to the ` Extensions Marketplace` and install the `Snyk Container Extension`
- On your command line you can now scan your Docker images with `docker scan your-docker-image`
- Disclaimer: Please follow any prompts `Snyk` requires you to fulfill to get up and running

#### .docker/config.json
```
{
	"auths": {
		"<account number>.dkr.ecr.eu-central-1.amazonaws.com": {},
		"https://index.docker.io/v1/": {}
	},
	"credsStore": "desktop",
	"currentContext": "desktop-linux"
}
```

### Helpful commands
#### List images
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

#### [Kind.sigs.k8s.io](https://kind.sigs.k8s.io/)
- Install [here](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- Kind allows you to use Docker to run K8s nodes as containers
- Get familiar with the basic commands
- Checkout the Kind documentation [here](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [Terms & Conditions](https://www.apache.org/licenses/LICENSE-2.0)

#### Why kind?
- kind supports multi-node (including HA) clusters
- kind supports building Kubernetes release builds from source
- support for make / bash or docker, in addition to pre-published builds
- kind supports Linux, macOS and Windows
- kind is a `CNCF certified conformant Kubernetes installer`

#### Istio on Kind
- [Kind platform setup](https://istio.io/latest/docs/setup/platform-setup/kind/)

### Helpful tool
#### Container Runtime Interface (CRI) CLI
- crictl is available [here](https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md)
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
#### Load Ortelius image onto the container nodes
```
kind load docker-image --name ortelius-in-a-box --nodes ortelius-in-a-box-control-plane,ortelius-in-a-box-worker,ortelius-in-a-box-worker2 quay.io/ortelius/ortelius
```
#### Load Keptn image onto the container nodes
```
kind load docker-image --name ortelius-in-a-box --nodes ortelius-in-a-box-control-plane,ortelius-in-a-box-worker ghcr.io/ortelius/keptn-ortelius-service:0.0.2-dev
```

#### [Kubernetes.io](https://kubernetes.io/)
- K8s is a production grade container orchestrater
- [Terms & Conditions](https://www.linuxfoundation.org/legal/terms#:~:text=Users%20are%20solely%20responsible%20for,arising%20out%20of%20User%20Content.)
- [Creative Commons](https://creativecommons.org/licenses/by/3.0/)

#### Kubectl
- Install `kubectl` the command line tool [here](https://kubernetes.io/docs/tasks/tools/)
- Use the `kubectl` cheat sheet [here](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- Use [Devdocs](https://devdocs.io/) and the official documentation [here](https://kubernetes.io/docs/home/)
- Add the `aliases` & `auto complete` which are in the `cheat sheet`

#### Helpful tools
#### Kubectx for switching context
```
kubectx kind-ortelius-in-a-box
```
#### Kubens for switching namespaces
```
kubens argocd
```
#### Combine Kubens & Kubectx with Fuzzy Finder
- kubectx is a tool to switch between contexts (clusters) on kubectl faster.
- kubens is a tool to switch between Kubernetes namespaces (and configure them for kubectl) easily.
- fzf is a general-purpose command-line fuzzy finder.
- fzf is an interactive Unix filter for command-line that can be used with any list; files, command history, processes, hostnames, bookmarks, git commits, etc.

- Download Fuzzy Finder [here](https://github.com/junegunn/fzf)
- Download Kubens & Kubectx [here](https://github.com/ahmetb/kubectx)

 ![kubectx with fuzzy finder!](images/k8s/kubens-kubectx-fuzzyfinder.jpg "kubectx with fuzzy finder")

### Octant | Graphical representation of your K8s Clusters

Octant is a tool for developers to understand how applications run on a Kubernetes cluster. It aims to be part of the developer's toolkit for gaining insight and approaching complexity found in Kubernetes. Octant offers a combination of introspective tooling, cluster navigation, and object management along with a plugin system to further extend its capabilities.
- Download [here](https://github.com/vmware-tanzu/octant)
- Documentation [here](https://octant.dev/docs/)
- Supports dark mode
- Plugins [here](https://github.com/topics/octant-plugin)

#### Notable Plugins
- [Helm](https://github.com/bloodorangeio/octant-helm)
- [Policy Report](https://github.com/evalsocket/policyreport-octant-plugin)

### Helm
- Install Helm [here](https://helm.sh/)
- Also known as the package manager for Kubernetes
#### Helm Dashboard
- GitHub page [here](https://github.com/komodorio/helm-dashboard
- Binds to all IPs `0.0.0.0:8080`
#### Install
```
helm plugin install https://github.com/komodorio/helm-dashboard.git
```
#### Update
```
helm plugin update dashboard
```
#### Uninstall
```
helm plugin uninstall dashboard
```
#### Please make sure you add the following Helm packages
```
helm repo add argo https://argoproj.github.io/argo-helm
```
```
helm repo add ortelius https://ortelius.github.io/ortelius-charts
```
```
helm repo add keptn-ortelius-service https://ortelius.github.io/keptn-ortelius-service
```
```
helm repo add istio https://istio-release.storage.googleapis.com/charts
```
#### Use `helm repo list` to make sure they are there
```
helm repo list
```
### Helpful tips
#### Update Helm repos
```
helm repo update
```
#### Lint
```
helm lint ./helm-appsofapps
```
#### Debug
```
helm template ./helm-appsofapps --debug
```
#### Dry-run
```
helm install argocd ./helm-appsofapps --dry-run
```
#### Dry-run with Debug
```
helm install argocd ./helm-appsofapps --dry-run --debug
```

### [Terraform](https://www.terraform.io/intro)
- Install Terraform [here](https://www.terraform.io/downloads)
- Documentation is [here](https://www.terraform.io/docs)
- [Terms & Conditions](https://registry.terraform.io/terms)
#### Steps to get going
- Clone `ortelius-in-a-box` [here](https://github.com/sachajw/ortelius-in-a-box)
- Navigate to `/terraform`
- Run the following
```
terraform init
```
```
terraform plan
```
```
terraform apply
```
- You should see something like this in Docker Desktop
![ortelius docker nodes!](images/docker/ortelius-nodes-docker.jpg "ortelius docker nodes")

### Helpful tips
#### Logs
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
