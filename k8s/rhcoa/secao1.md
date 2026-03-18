# Configurations to start the EXAM

> [!TIP] 
>
> Set the Openshift as the bundle image before start CRC with:
>
> `crc config set preset openshift`
>
> To enable the monitoring to let check for cluster metrics: `crc config set memory 14336` then `crc config set enable-cluster-monitoring true` before starting the cluster
>
> When staring CRC use: `crc start -d 40` to bootstrap with a disk size of 40G to let all the necessary exam labs to be provisioned

> [!TIP]
>
> To be able to use some operators like metallb that requires a valid network must be necessary to configure the cluster network by creating some config files and changing the crc config with:
>
> Change the `crc` network config:
>
> `crc config set network-mode system` 
>
> Create user for network configuration. Reference: https://crc.dev/docs/networking/
>
> ```bash
> #!/bin/sh 
>
>export LC_ALL=C 
>
>systemd-resolve --interface crc --set-dns 8.8.8.8 --set-dns 1.1.1.1 --set-domain ~testing 
>
>exit 0
> ```
> 
> If it doesn't work must be necessary to do:
>
> `sudo vim /etc/systemd/resolved.conf`
> and add to it:
> ```ini
> [Resolve]
> DNS=8.8.8.8 1.1.1.1
> FallbackDNS=8.8.4.4 
> ```
>
> And then restart the systemd-resolved `sudo systemctl restart systemd-resolved`
>
> Then delete the `crc` instante and recreate it: `crc delete` and `crc setup` then `crc start -d 40`

> [!WARNING]
>
> There is a open issue https://github.com/crc-org/crc/issues/5034 to solve the problem that the operators catalog are not available.
> 
> To bypass this is necessary to execute:
>
> ```bash
> oc patch clusterversion version --type=json -p '[{"op": "add", "path": "/spec/capabilities/additionalEnabledCapabilities/-", "value": "CloudCredential"}]'
> oc patch clusterversion version --type='json' -p='[{"op": "replace", "path": "/spec/overrides/0/unmanaged", "value": false}]'
> oc patch clusterversion version --type='json' -p='[{"op": "replace", "path": "/spec/overrides/1/unmanaged", "value": false}]'
> ```
>
> Then validate with:
>
> `oc get co cloud-credential`
> 
> Desired output:
>
> ```
> NAME               VERSION   AVAILABLE   PROGRESSING   DEGRADED   SINCE   MESSAGE
>cloud-credential   4.20.5    True        False         False      3m22s   
> ```

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
oc new-project nfs-storage
oc adm policy add-scc-to-user privileged -z nfs-client-provisioner -n nfs-storage
oc adm policy add-scc-to-user restricted -z nfs-client-provisioner -n nfs-storage
oc adm policy add-scc-to-user anyuid -z nfs-client-provisioner -n nfs-storage
oc adm policy add-scc-to-user hostmount-anyuid -z nfs-client-provisioner -n nfs-storage
oc apply -f nfs/
```

Apply pvc and pod tests in some namespace

```bash
oc new-proejct test-nfs
oc apply -f nfs/test-pvc/
oc get pvc
watch oc get all
```

