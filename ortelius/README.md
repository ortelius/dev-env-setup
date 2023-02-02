# Ortelius

Microservice Configuration Management - Track, Version, Find, Share and Deploy Microservices

[Overview of Ortelius](https://ortelius.io)

## TL;DR

```console
openssl genpkey -out jwt.pri -algorithm RSA -pkeyopt rsa_keygen_bits:2048
openssl pkey -in jwt.pri -pubout -out jwt.pub
helm repo add ortelius https://ortelius.github.io/ortelius-charts/
helm install my-release ortelius/ortelius --set ms-general.dbpass=my_db_password --set ms-nginx.ingress.type=ssloff --set ms-general.dbhost=orteliusdb.us-east-1.rds.amazonaws.com --set-file ms-general.jwt.privatekey=jwt.pri --set-file ms-general.jwt.publickey=jwt.pub
```

## Introduction

This chart deploys all of the required secrets, services, and deployments on a [Kubernetes](https://kubernetes.io) cluster using the [Helm](https://helm.sh) package manager.

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- Public/Private RSA PKCS#8 Key Pair for JWT Tokens
- External Postgres Database

## Installing the Chart

To install the chart with the release name `my-release`:

```console
helm install my-release ortelius/ortelius --set ms-general.dbpass=my_db_password --set ms-general.dbhost=orteliusdb.us-east-1.rds.amazonaws.com --set ms-nginx.ingress.type=ssloff --set-file ms-general.jwt.privatekey=jwt.pri --set-file ms-general.jwt.publickey=jwt.pub
```

The command deploys DeployHub on the Kubernetes cluster using the following parameters:
- ms-general.dbpass = Postgres Database Password
- ms-general.dbhost = Postgres Database Hostname
- ms-nginx.ingress.type = ssloff (Disable the use of SSL certificates)
- ms-general.jwt.privatekey = Private RSA PKCS#8 Key for creating the JWT Token
- ms-general.jwt.publickey = Public RSA PKCS#8 Key for creating the JWT Token

> **Tip**: List all releases using `helm list`

## Uninstalling the Chart

To uninstall/delete the `my-release` deployment:

```console
helm delete my-release
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

## Parameters

### Common parameters

| Name                     | Description                                                                                  | Value           |
| ------------------------ | -------------------------------------------------------------------------------------------- | --------------- |
| `ms-general.dbuser`     | Postgres Database User Name                                                                  | `postgres`      |
| `ms-general.dbpass`     | Postgres Database Password                                                                   | `postgres`      |
| `ms-general.dbname`     | Postgres Database Name                                                                       | `postgres`      |
| `ms-general.dbhost`     | Postgres Database Host Name                                                                  | `localhost`     |
| `ms-general.dbport`     | Postgres Database Port                                                                       | `5432`          |
| `ms-nginx.ingress.type` | ssloff = non ssl enabled, alb = add alb ingress, volumemnt = certs come from existing ssl volume, sslcert = add certs a opaque secret | `sslcert, alb, volumemnt, ssloff`  |
| `ms-nginx.ingress.sslcert.chainedcert`    | SSL Chained Certificate - required when `dh-ms-nginx.ingress.type=sslcert`                     | `SSL Chained Certificate - decoded` |
| `ms-nginx.ingress.sslcert.privatekey`    | SSL Private Key for SSL Chained Cert - required when `dh-ms-nginx.ingress.type=sslcert`         | `SSL Private Key - decoded`         |
| `ms-nginx.ingress.alb_subnets`    | String of comma delimited subnets for the ALB - required when  `dh-ms-nginx.ingress.type=alb`  |   |
| `ms-nginx.ingress.alb_certificate_arn`    | ARN for the certificate from AWS Certificate Manager - required when  `dh-ms-nginx.ingress.type=alb` |  |
| `ms-nginx.ingress.dnsname`    | DNS Name that matches the certificate from AWS Certificate Manager - required when  `ms-nginx.ingress.type=alb` |  |
| `ms-nginx.ingress.scheme`    | ALB scheme - required when  `dh-ms-nginx.ingress.type=alb` |  `internal` or `internet-facing` default: `internal`|
| `ms-general.jwt.privatekey` | Private RSA PKCS#8 Key used to create JWT Tokens                                            | `Private RSA PKCS#8 Key - decoded` |
| `ms-general.jwt.publickey`  | Public RSA PKCS#8 Key used to create JWT Tokens                                             | `Public RSA PKCS#8 Key - decoded`  |

> NOTE: Once this chart is deployed, it is not possible to change the application's access credentials, such as usernames or passwords, using Helm. To change these application credentials after deployment, delete any persistent volumes (PVs) used by the chart and re-deploy it, or use the application's built-in administrative tools if available.

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example,

```console
helm install my-release -f values.yaml ortelius/ortelius
```
