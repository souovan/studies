# Configurations to start the EXAM

> [!TIP] 
>
> Set the Openshift as the bundle image before start CRC with:
>
> `crc config set preset openshift`
>
> When staring CRC use: `crc start -d 40` to bootstrap with a disk size of 40G to let all the necessary exam labs to be provisioned

* Login on console.redhat.com
    - navigate to Containers > Clusters
    - click on create cluster then Local tab and follow the instructions
* Complete de `crc` CLI setup to bootstrap the local okd cluster
<!-- * After the crc VM (OKD) goes up login in the WebUI, get the token to login in the `oc` cli
    - Get shell into the node with `oc debug node/crc`
    - Run `chroot /host`
    - Login into redhat catalog registry with customer credentials `podman login registry.redhat.io` -->
* Create a secret for authentication on the private registry
```bash
oc create secret docker-registry redhat-registry-secret \
  --docker-server=registry.redhat.io \
  --docker-username=souovan \
  --docker-password=<secret>
```
* Attach the secret to the ServiceAccount with `oc secrets link default redhat-registry-secret --for=pull`

## Create the NFS storageclass

On the host machine where crc vm resides, prepare to be NFS server

```bash
sudo dnf install -y nfs-utils
sudo mkdir -p /srv/nfs/kubedata
sudo chmod 775 /srv/nfs/kubedata
sudo vi /srv/nfs/kubedata/index.html
# Add
NFS LAB!!
sudo vi /etc/exports
# Add 
/srv/nfs/kubedata *(rw,sync,no_root_squash,no_subtree_check,insecure)
sudo systemctl enable --now nfs-server
sudo exportfs -rav
# Enable the firewall
sudo firewall-cmd --add-service=nfs --permanent
sudo firewall-cmd --reload
sudo systemctl restart nfs-server
# check firewall
sudo firewall-cmd --list-all
```

Validate the connection on the crc node

```bash
oc debug $(oc get nodes -o name | head -1)
chroot /host
showmount -e <IP of host machine>
```

Create the NFS storageclass objects

```bash
oc create ns nfs-storage
oc apply -f nfs/
oc adm policy add-scc-to-user privileged -z nfs-client-provisioner -n nfs-storage
oc adm policy add-scc-to-user restricted -z nfs-client-provisioner -n nfs-storage
oc adm policy add-scc-to-user anyuid -z nfs-client-provisioner -n nfs-storage
oc adm policy add-scc-to-user hostmount-anyuid -z nfs-client-provisioner -n nfs-storage
```

Apply pvc and pod tests in some namespace

```bash
oc create ns test-nfs
oc project test-nfs
oc apply -f nfs/test-pvc/
oc get pvc
watch oc get all
```

