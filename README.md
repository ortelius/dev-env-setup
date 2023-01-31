# [Ortelius](https://ortelius.io/) & [Localstack](https://docs.localstack.cloud/overview/) Local Deployment
- [Ortelius \& Localstack Local Deployment](#ortelius--localstack-local-deployment)
  - [What you need?](#what-you-need)
  - [Kind Ortelius Cluster Details](#kind-ortelius-cluster-details)
    - [Context `kind-ortelius`](#context-kind-ortelius)
    - [Namespaces `ortelius` `localstack`](#namespaces-ortelius-localstack)
    - [Nodes](#nodes)
  - [Docker.com](#dockercom)
    - [GitHub Docker](#github-docker)
  - [Terraform](#terraform)
    - [GitHub Terraform](#github-terraform)
      - [Terraform README](#terraform-readme)
      - [Lets get going](#lets-get-going)
      - [Time the deployment](#time-the-deployment)
      - [Don't time the deployment](#dont-time-the-deployment)
      - [Destroy the deployment](#destroy-the-deployment)
      - [Logs](#logs)
  - [KinD](#kind)
    - [GitHub KinD](#github-kind)
    - [Why KinD?](#why-kind)
      - [Get Nodes](#get-nodes)
      - [Kubeconfig](#kubeconfig)
      - [Get Clusters](#get-clusters)
      - [Logs | Great for debugging \& troubleshooting](#logs--great-for-debugging--troubleshooting)
  - [Container Runtime Interface (CRI) CLI](#container-runtime-interface-cri-cli)
    - [GitHub Crictl](#github-crictl)
      - [List containers and check the container is in a created state](#list-containers-and-check-the-container-is-in-a-created-state)
      - [Start container](#start-container)
      - [Exec a command in a container](#exec-a-command-in-a-container)
  - [Kubernetes.io](#kubernetesio)
    - [GitHub Kubernetes](#github-kubernetes)
      - [Kubectl](#kubectl)
      - [Combine Kubens \& Kubectx with Fuzzy Finder](#combine-kubens--kubectx-with-fuzzy-finder)
      - [FzF](#fzf)
      - [FzF in action](#fzf-in-action)
      - [Kubectx for switching context](#kubectx-for-switching-context)
      - [Kubens for switching namespaces](#kubens-for-switching-namespaces)
  - [Octant](#octant)
    - [GitHub Octant](#github-octant)
      - [Notable Plugins](#notable-plugins)
      - [Octant Port Forward to an Endpoint](#octant-port-forward-to-an-endpoint)
  - [Localstack](#localstack)
    - [GitHub LocalStack](#github-localstack)
      - [AWS CLI Local](#aws-cli-local)
      - [Configurations](#configurations)
      - [AWS Copilot](#aws-copilot)
      - [AWS Lamba Golang Runtime](#aws-lamba-golang-runtime)
      - [LocalStack Java Utils](#localstack-java-utils)
        - [Prerequisites](#prerequisites)
      - [LocalStack Container](#localstack-container)
      - [LocalStack S3 Endpoint](#localstack-s3-endpoint)

## What you need?
- Docker
- Kind
- Kubectl
- Terraform
- Localstack
- Operating System agnostic

## Kind Ortelius Cluster Details
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
### Namespaces `ortelius` `localstack`
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
### [GitHub Docker](https://github.com/docker)

Docker is a platform for developing, shipping, and running applications. It uses containers, which are lightweight, standalone, executable packages of software that include everything needed to run the application, including the code, runtime, libraries, environment variables, and system tools. Containers provide a consistent, isolated environment for applications to run, making it easier to develop, test, and deploy applications. Docker allows developers to automate the deployment of applications into containers and manage containers as a single unit. It simplifies the process of deploying applications, making it easier to scale applications, and enabling organizations to adopt a microservices architecture.

- [Account setup](https://hub.docker.com/signup)
- [Install](https://docs.docker.com/get-docker/)
- Get familiar with the basic commands
- Use [Devdocs](https://devdocs.io/) and the Docker documentation [here](https://docs.docker.com/)
- [Terms & Conditions](https://www.docker.com/legal/docker-terms-service/)

## [Terraform](https://www.terraform.io/intro)
### [GitHub Terraform](https://github.com/hashicorp/terraform)

Terraform is an open-source tool for provisioning and managing infrastructure as code. It provides a simple, declarative syntax for defining infrastructure resources, such as virtual machines, DNS entries, and databases. Terraform can manage popular service providers as well as custom in-house solutions. By describing infrastructure as code, Terraform enables versioning, testing, and collaboration of infrastructure changes. Terraform can create, update, and delete resources in parallel, while minimizing the risk of conflicts and errors. Terraform also provides a state management system that tracks changes to infrastructure over time, making it easier to roll back changes if necessary. With Terraform, organizations can automate their infrastructure management processes, improve reliability, and increase efficiency.

#### [Terraform README](TF-README.md)
- Install Terraform [here](https://www.terraform.io/downloads)
- Documentation is [here](https://www.terraform.io/docs)
- [Terms & Conditions](https://registry.terraform.io/terms)

#### Lets get going
- Clone the repo
- Navigate to `/`
- Run the following
```
terraform init
```
```
terraform plan
```
#### Time the deployment
```
time terraform apply --auto-approve
```
#### Don't time the deployment
```
terraform apply --auto-approve
```
#### Destroy the deployment
```
terraform destroy --auto-approve
```
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

## [KinD](https://kind.sigs.k8s.io/)
### [GitHub KinD](https://github.com/kubernetes-sigs/kind)

Kind (Kubernetes in Docker) is a tool for running local Kubernetes clusters using Docker containers as nodes. It provides an easy-to-use environment for testing and developing applications that run on a Kubernetes cluster. Kind allows developers to run a full Kubernetes cluster on their development machine, eliminating the need for remote clusters and making it easier to test and debug applications. Kind creates a multi-node cluster by launching multiple Docker containers on a single host, making it possible to test complex scenarios and network configurations. Kind is also useful for testing Kubernetes plugins and extensions, and for developing and testing operators, custom controllers, and other Kubernetes-related software.

- Install [here](https://kind.sigs.k8s.io/docs/user/quick-start/#installation)
- Documentation is [here](https://kind.sigs.k8s.io/docs/user/quick-start/)
- [Terms & Conditions](https://www.apache.org/licenses/LICENSE-2.0)

### Why KinD?
- kind supports multi-node (including HA) clusters
- kind supports building Kubernetes release builds from source
- support for make / bash or docker, in addition to pre-published builds
- kind supports Linux, macOS and Windows
- kind is a `CNCF certified conformant Kubernetes installer`

![KinD Nodes!](images/kind/01-kind-nodes.jpg)

#### Get Nodes
```
kind get nodes ortelius
```
#### Kubeconfig
```
kind get kubeconfig -n ortelius
```
#### Get Clusters
```
kind get clusters
```
#### Logs | Great for debugging & troubleshooting
```
kind export logs -n ortelius
```

## [Container Runtime Interface (CRI) CLI](https://kubernetes.io/docs/tasks/debug/debug-cluster/crictl/)
### [GitHub Crictl](https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md)

Crictl is a command line tool for interacting with a containerd-based container runtime. It provides a simple, human-readable interface for performing common container operations such as pulling images, starting and stopping containers, and viewing logs. Crictl also supports advanced features such as executing commands inside containers and managing network configurations. It is designed to be a fast and flexible alternative to other container runtime management tools, and can be used in production or development environments. Crictl is a component of the containerd project, which is a lightweight, high-performance runtime for managing containers and is used by many popular container orchestration platforms such as Kubernetes.

- Download crictl [here](https://github.com/kubernetes-sigs/cri-tools/blob/master/docs/crictl.md)

#### List containers and check the container is in a created state
```
$ crictl ps -a
CONTAINER ID        IMAGE               CREATED             STATE               NAME                ATTEMPT
3e025dd50a72d       busybox             32 seconds ago      Created             busybox             0
```
#### Start container
```
$ crictl start 3e025dd50a72d956c4f14881fbb5b1080c9275674e95fb67f965f6478a957d60
3e025dd50a72d956c4f14881fbb5b1080c9275674e95fb67f965f6478a957d60

$ crictl ps
CONTAINER ID        IMAGE               CREATED              STATE               NAME                ATTEMPT
3e025dd50a72d       busybox             About a minute ago   Running             busybox             0
```
#### Exec a command in a container
```
crictl exec -i -t 3e025dd50a72d956c4f14881fbb5b1080c9275674e95fb67f965f6478a957d60 ls
bin   dev   etc   home  proc  root  sys   tmp   usr   var
```

## [Kubernetes.io](https://kubernetes.io/)

Kubernetes is an open-source platform for automating deployment, scaling, and management of containerized applications. It provides a unified API for defining and managing containers, enabling organizations to simplify the deployment and scaling of applications. Kubernetes automates the distribution of containers across a cluster of machines and monitors the health of the containers, ensuring that they are always running. It can automatically replace failed containers and ensure that the desired number of replicas are running. Kubernetes also provides built-in service discovery and load balancing, making it easier to connect microservices and ensure that traffic is distributed evenly across the cluster. Kubernetes has become the de facto standard for container orchestration and is widely adopted by organizations of all sizes.

### [GitHub Kubernetes](https://github.com/kubernetes-sigs)
- [Terms & Conditions](https://www.linuxfoundation.org/legal/terms#:~:text=Users%20are%20solely%20responsible%20for,arising%20out%20of%20User%20Content.)
- [Creative Commons](https://creativecommons.org/licenses/by/3.0/)
#### Kubectl
- Install `kubectl` the command line tool [here](https://kubernetes.io/docs/tasks/tools/)
- Use the `kubectl` cheat sheet [here](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)
- Use [Devdocs](https://devdocs.io/) and the official documentation [here](https://kubernetes.io/docs/home/)
- Add the `aliases` & `auto complete` which are in the `cheat sheet`

#### Combine Kubens & Kubectx with Fuzzy Finder
- `kubectx` is a tool to switch between contexts (clusters) on kubectl faster.
- `kubens` is a tool to switch between Kubernetes namespaces (and configure them for kubectl) easily.
- Download `Kubens & Kubectx` [here](https://github.com/ahmetb/kubectx)

#### FzF
- Is a general-purpose command-line fuzzy finder.
- Is an interactive Unix filter for command-line that can be used with any list; files, command history, processes, hostnames, bookmarks, git commits, etc.
- Download `Fuzzy Finder` [here](https://github.com/junegunn/fzf)

#### FzF in action

![Fuzzy Finder!](images/fzf/01-fzf-example.jpg)

#### Kubectx for switching context
```
kubectx kind-ortelius
```
#### Kubens for switching namespaces
```
kubens ortelius
```

## [Octant](https://octant.dev/)
### [GitHub Octant](https://github.com/vmware-archive/octant)

Octant is a web-based graphical user interface (GUI) for exploring and analyzing the resources in a Kubernetes cluster. Octant provides a visual representation of a cluster's resources, including deployments, pods, services, and configurations. It allows developers and administrators to view and analyze the health and performance of their applications, and provides insights into the resource utilization of the cluster. Octant also provides an interactive environment for exploring and modifying the cluster's resources, making it easier to diagnose and resolve issues. Octant is designed to be highly extensible and can be integrated with other tools and services to provide a complete end-to-end experience for managing and monitoring Kubernetes clusters. Octant is an open-source project, and provides a fast, lightweight, and modern alternative to traditional command line tools for managing and analyzing Kubernetes clusters.

- Download [here](https://github.com/vmware-tanzu/octant)
- Documentation [here](https://octant.dev/docs/)
- Supports dark mode
- Plugins [here](https://github.com/topics/octant-plugin)

#### Notable Plugins
- [Helm](https://github.com/bloodorangeio/octant-helm)
- [Policy Report](https://github.com/evalsocket/policyreport-octant-plugin)

#### Octant Port Forward to an Endpoint
![Octant Port Forward to S3!](images/octant/01-octant-port-forward-s3.jpg)

## [Localstack](https://docs.localstack.cloud/overview/)
### [GitHub LocalStack](https://github.com/localstack)

LocalStack is a fully functional local AWS cloud stack that enables developers to develop and test their cloud applications offline. It provides an easy-to-use test/mocking framework for developing cloud applications, eliminating the need for a live AWS environment.

- LocalStack is installed using Helm Charts via Terraform [here](https://github.com/localstack/helm-charts)
- [LocalStack Quickstart](https://docs.localstack.cloud/getting-started/quickstart/)
- [Localstack Serverless Plugin](https://github.com/localstack/serverless-localstack)
- `IMPORTANT` The hardcoded port comes from the LocalStack Helm Chart values.yaml - e.g. http://localhost:31566
- You can get the node port in Octant by referring to this image [Octant Port Forward to an Endpoint](#octant-port-forward-to-an-endpoint)

#### [AWS CLI Local](https://github.com/localstack/awscli-local)
- This package provides the `awslocal` command, which is a thin wrapper around the aws command line interface for use with LocalStack.

#### [Configurations](https://docs.localstack.cloud/references/configuration/)

You can use the following environment variables for configuration:
- `LOCALSTACK_HOST`: Set the hostname for the LocalStack instance.
- Useful when you have LocalStack bound to a different host (e.g., within docker-compose).
- `EDGE_PORT`: Port number to use when connecting to LocalStack services. Defaults to 4566.
- `USE_SSL`: Whether to use https endpoint URLs. Defaults to false.
- `DEFAULT_REGION`: Set the default region. Overrides `AWS_DEFAULT_REGION` environment variable.

```
aws --endpoint-url=http://localhost:4566 kinesis list-streams
StreamNames: []
```
#### [AWS Copilot](https://github.com/localstack/copilot-cli-local)
- This repo provides copilotlocal, a command-line interface (CLI) with the same features as the original copilot CLI, but using the local API endpoints provided by LocalStack.
- The patch applied in this repo essentially redirects any AWS API calls to the local endpoints under [http://localhost:4566](http://localhost:4566).

#### [AWS Lamba Golang Runtime](https://github.com/localstack/awslamba-go-runtime)
- Custom Golang runtime for the execution of AWS Lambdas used in LocalStack.
- This is a modification of the custom runtime of lambda ci.
- This custom runtime avoids using the /var folder as main place where to locate other files.
- It contains the source code of the docker-lambda mockserver to build the binary.

#### [LocalStack Java Utils](https://github.com/localstack/localstack-java-utils)

Java utilities and JUnit integration for LocalStack.

##### Prerequisites
- Java
- Maven
- Docker
- LocalStack

#### LocalStack Container
![Localstack on Kind!](images/localstack/01-localstack-kind-pod.jpg)

#### LocalStack S3 Endpoint
![LocalStack S3 Endpoint!](images/localstack/02-localstack-s3-endpoint.jpg)
