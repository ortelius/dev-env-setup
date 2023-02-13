# Installation

First you will need to install the secrets

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: postgres-secrets
  namespace: backstage
type: Opaque
stringData:
  POSTGRES_USER: backstage
  POSTGRES_PASSWORD:
---
apiVersion: v1
kind: Secret
metadata:
  name: backstage-secrets
  namespace: backstage
type: Opaque
data:
  GITHUB_TOKEN:
```

To Create the secret for ghcr

```bash
kubectl create secret docker-registry ghcr --docker-server=ghcr.io --docker-username=bradmccoydev --docker-password=<enter-here> --docker-email=bradmccoydev@gmail.com -n backstage
```

### 2. Add Helm Repo

```bash
helm repo add backstage https://ortelius.github.io/backstage
```

Update if required
```bash
helm repo update backstage
```

### 3. Install Helm Chart
```bash
helm install backstage ortelius/backstage
```
