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


