# Configurations to start the EXAM

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
  --docker-password=s9M6QyiqyPsAkX8
```
* Attach the secret to the ServiceAccount with `oc secrets link default redhat-registry-secret --for=pull`
