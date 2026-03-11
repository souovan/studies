# Commands for the EXAM

## Openshift Cluster Operators

```bash
# Check resource events
oc get events
```

```bash
# Check resource logs
oc logs <pod>
```

```bash
# Edit some resource content
oc edit <resource>
```

---

## Openshift authentication

```bash
# Check for kubeadmin user secret
oc describe secrets -n kube-system kubeadmin
```

```bash
# Check for user permissions
oc auth can-i --list
```

## Openshift Storage

Container with persistent database

```bash
# Check storageclass info
oc get storageclass
```

### PVC/PV

```bash
# Create a volume and attach to a existing deployment
oc set volumes deployment/postgres-persistent --add --name postgres-storage --type pvc --claim-class crc-csi-hostpath-provisioner --claim-mode rwo --claim-size 2Gi --mount-path /var/lib/pgsql --claim-name postgresql-storage
```

### Helm Charts

```bash
# list if charts is added locally
helm repo list
```

```bash
# add a new repo
helm repo add <url>
```

```bash
# check charts available locally
helm search repo 

# check charts versions available locally
helm search repo --versions
```

```bash
# install a chart
helm install <chart-name> <chart-name> --version <x.y.z>
```

> [!TIP]
>
> To train for the exam
> ```bash
> # Install the training helm repo charts
> helm repo add redhat-cop https://redhat-cop.github.io/helm-charts
> # Search for charts in the training repo
> helm search repo redhat-cop
> # Install an example chart
> helm install etherpad --version 0.0.8 redhat-cop/etherpad
> ```

## Openshift Template

```bash
# Check the template (if) available
oc get template -n openshift-config -o yaml
```

```bash
# Check the project template
oc get project.config -o yaml
```

```bash
# Creates a bootstrap template
oc adm create-bootstrap-project-template -o yaml
```

```bash
# If any changes are made in the template of namespace openshift-config, check pods of namespace openshift-apiserver
oc get pods -n openshift-apiserver
```

## Openshift support information

```bash
# Get informations about the cluster and filter the cluster ID
oc get clusterversion version -o yaml | grep clusterID
```