# Tips and tricks

Interesting commands

## vim

```bash
set et
set ai
set cuc
set ts=2
set paste
```

## Openshift Cluster Operators

```bash
# Identify the current user
oc whoami
```

```bash
# Get the WebUI URL
oc whoami --show-console
```

```bash
# Check cluster info
oc get clusterversion
```

```bash
# Check cluster operators info
oc get clusteroperators
```

```bash
# Check pods by operator
oc get pods -n openshift-<operator-name>
```

```bash
# Check pods by operator with info about node they are running
oc get pods -n openshift-<operator-name> -o wide
```

```bash
# Check nodes health
oc adm top node
```

```bash
# Check node info
oc describe node
```

---

## Openshift Storage

```bash
# Command to populate a postgresql database with a given .sql file
oc exec deployment.apps/postgresql-persistent -i redhat123 -- /usr/bin/psql -U redhat peristentdb < init_data.sql
```

## Openshift Authentication & Authorization

```bash
# Check for users available in the cluster
oc get identity
```

```bash
# Check the htpasswd file / secret if it exists
oc get secret htpass-secret -n openshift-config -o yaml
```

> [!TIP]
>
> When the permission is cluster wide must use `oc adm policy...`
> 
> When the permission is local or focused in a single project must use `oc policy...`

```bash
# Check wich group has some role
oc describe clusterrolebinding | grep self-provisioner -A4
```

```bash
# To remove permission to create project from all users
oc adm policy remove-cluster-role-from-group self-profisioner system:authenticated:oauth
```

```bash
# Check permissions by namespace
oc policy who-can get pods -n <namespace>
```

### Login method htpasswd

> [!TIP]
> 
> Installs the htpasswd CLI
> `sudo dnf install -y httpd-tools`

```bash
# Creates a htpasswd file and add user to it
htpasswd -c -B -b htpasswd admin redhat
htpasswd -b htpasswd dev dev
```

```bash
# Create a secret within the htpasswd file
oc create secret generic localusers --from-file htpasswd=htpasswd -n openshift-config
```

```bash
# Add permission to user
oc adm policy add-cluster-role-to-user cluster-admin admin
```

To add new user to the cluster with HTPasswd method:

* Get and edit the oauth controller from cluster

```bash
# Get the oauth config controller
oc get oauth cluster -o yaml
```

* Update it adding:

```yaml
spec:
  identityProviders:
  - htpasswd:
      fileData:
        name: localusers
    mappingMethod: claim
    name: myusers
    type: HTPasswd
```

* Re-apply it to cluster

```bash
# Reapply to cluster
oc replace -f oauth.yaml
```

> [!TIP]
> Help to Remember oauth controller sintax
>
> `oc explain oauth.spec.identityProviders`

* Wait until the pods are restart

```bash
oc get pods -n openshift-authentication
```

### RBAC

```bash
# Get the clusterrole example, some available roles: basic-user, view, edit, self-provisioner, cluster-status, cluster-admin
oc get clusterrole basic-user -o yaml
```

## Security

```bash
# Run a pod to attach secret as volume
oc new-project authorization-secrets

oc new-app --name mysql --image registry.redhat.io/rhel8/mysql-80:1
```

```bash
# Secret as file in a pod
oc create secret generic mysql --from-literal user=myuser --from-literal password=redhat123 --from-literal database=test_secrets --from-literal hostname=mysql

oc set volume deployment/mysql --add --type secret --mount-path /run/secrets/mysql --secret-name mysql
```

```bash
# Set credentials from secret as ENV to a existing deployment/pod
oc set env deployment/mysql --from secret/mysql --prefix MYSQL_
```

```bash
# To test if the attached secret work in the pod
oc rsh pod/<pod-id>
# then
mysql -u myuser --password=redhat123 test_secrets -e 'show databases;'
```

### SCCs

```bash
# Get SCCs list
oc get scc
```

```bash
# Create a pod that requires some privileged SCC
oc new-project authorization-scc
# then
oc new-app --name gitlab --image quay.io/redhattraining/gitlab-ce:8.4.3-ce.0
```

```bash
# Check what SCCs permission a resource requires
oc get pod/<pod-id> -o yaml | oc adm policy scc-subject-review -f -
```

```bash
# Create a ServiceAccount to attach the right SCC required by the resource
oc create sa gitlab-sa
```

```bash
# Assign the SCC to SA
oc adm policy add-scc-to-user restricted-v2 -z gitlab-sa
# Attach the ServiceAccount to the resource
oc set serviceaccount deployment/gitlab gitlab-sa
```

## Pod Scheduling Behavior

```bash
# Change replicas quantity, the nodes where the pods will placed will be random
oc scale --replicas 4 deploy/<deploy>
```

```bash
# Check if nodes has any ENV
oc get nodes -L env
```

```bash
# Check all labels from nodes
oc get nodes --show-labels
```

```bash
# Add label to a node
oc label node master01 env=dev
```

```yaml
# Controle scheduling of pods by adding nodeSelector config to deployment
# oc explain deployment.spec.template.spec.nodeSelector
nodeSelector:
  env: dev
```

## Limiting resources consumed by containers, pods and projects

Quotas are applied at project level and Limits are applied at resources level, like deployment, pod etc

### LimitRanges

```yaml
# Limitrange sample
apiVersion: v1
kind: LimitRange
metadata:
  name: mem-limit-range
  namespace: default
spec:
  limits:
    - default:
        memory: 512Mi
      defaultRequest:
        memory: 256Mi
      type: Container
```

### Quotas

```bash
# Creates a quota at project
oc create quota project-quota --hard cpu="3",memory="1G",configmaps="2" -n schedule-limit
```
---

```yaml
# Configures Limits to pods on deployment at 
# oc explain deployment.spec.template.spec.containers.resources
resources:
  requests:
    cpu: 100Mi
    memory: 200Mi
  limits:
    cpu: 300Mi
    memory: 500Mi
```

## Networking

Terminations

### Edge Route

With edge termination, TLS termination occurs at the router, before the traffic is routed to the pods. The router serves the TLS certificates, so you must configure them into the route; otherwise, Openshift assings its own certificate to the router for TLS termination. Because TLS is terminated at the router, connections from the router to the endpoints over the internal network are not encrypted.

```
                                                                   ┌───────────────────┐
                      ┌───────────────────────────────┐            │ ┌───────────────┐ │
                      │ ┌─────────────────────────┐   │            │ │               │ │
╭─────────╮    y      │ │ ┌─────────┐ ┌─────────┐ │   │     x      │ │  application  │ │
│         │           │ │ │ tls.crt │ │ tls.key │ │   │            │ │               │ │
│ Client  │ ──────►   │ │ └─────────┘ └─────────┘ │   │ ─────────► │ │               │ │
│         │           │ │          encryption     │   │            │ └───────────────┘ │
╰─────────╯           │ └─────────────────────────┘   │            │                   │
                      │          edge route           │            │     container     │
                      └───────────────────────────────┘            │                   │
                                                                   └───────────────────┘
```

### Passthrough Route

With passthrough termination, encrypted traffic is sent straight to the destination pod without the router providing TLS termination. In this mode, the application is responsible for serving certificates for the traffic. Passthrough is currently the only method that support mutual authentication between the application and a client that access it.

```
                                                      ┌─────────────────────────────────────────────────┐
                                                      │┌───────────────────────────────────────────────┐│
                                                      ││ ┌───────────────────────────────────────────┐ ││
                                                      ││ │ ┌─────────────┐         ┌───────────────┐ │ ││
                        ┌────────────────────┐        ││ │ │   tls.crt   │         │    tls.key    │ │ ││
┌──────────┐     y      │                    │        ││ │ └─────────────┘         └───────────────┘ │ ││
│          │            │                    │        ││ │    │           encryption        │        │ ││
│  client  │  ───────►  │  passthough route  │ ──────►││ └────│─────────────────────────────│────────┘ ││
│          │            │                    │        ││      │           application       │          ││
└──────────┘            │                    │        │└──────│─────────────────────────────│──────────┘│
                        └────────────────────┘        │       │                             │           │
                                                      │       │                             │           │
                                                      │       ▼                             ▼           │
                                                      │┌───────────────────────────────────────────────┐│
                                                      ││  Mounts:                                      ││
                                                      ││  /usr/local/etc/ssl/certs from tls-certs (ro) ││
                                                      │└───────────────────────────────────────────────┘│
                                                      │        ▲            container                   │
                                                      └────────│────────────────────────────────────────┘
                                                               │                                         
                                                               │                                         
                                                               │                                         
                                                               │                                         
                                                               │                                         
                                                             ┌────────────────────────────────────────┐  
                                                             │                                        │  
                                                             │ volumeMounts:                          │  
                                                             │ - name: tls-certs                      │  
                                                             │   readOnly: true                       │  
                                                             │   mountPath: /usr/local/etc/ssl/certs  │  
                                                             │ -                                      │  
                                                             │ volumeMounts:                          │  
                                                             │ - name: tls-certs                      │  
                                                             │   secret:                              │  
                                                             │     secretName: todo-certs             │  
                                                             │                                        │  
                                                             └────────────────────────────────────────┘  
```

### Re-encryption

Re-encryption is a variation on edge termination, whereby the router terminates TLS with a certificate, and then re-encrypts its connection to the endpoint, which might have a different certificate. Therefore, the full path of the connection is encrypted, even over the internal network. The router uses health checks to determine the autehticity of the host.

```bash
# Creates a route without Termination
oc expose svc <svc-name>
```

```bash
# Create a route with Termination edge that provides a TLS cluster wildcard certificate
oc create route edge <name> --service=<svc> --hostname=<url>
```

```bash
# Create a route with Termination edge providing the TLS certificates
oc create route edge <name> --service=<svc> --key <key> --cert <cert> --hostname <URL>
```

```bash
# Creates a route with Termination passthrough providing a certificate from secret

# Generate certificates
openssl genrsa -out training.key 4096

openssl req -new \
-subj "/C=US/ST=North Carolina/L=Raleigh/O=Red Hat/CN=todo-https.apps.ocp4.example.com" \
-key training.key -out training.csr

openssl x509 -req in training.csr \
-passin file:passphrase.txt
-CA training-CA.pem -CAkey training-CA.key -CAcreateserial \
-ou training.crt -days 1825 -sha256 -extfile training.ext

# or simpler
openssl x509 -req -days 366 -in training.csr -signkey training.key -out training.crt

# Create the secret
oc create secret tls <name> --cert training.crt --key training.key

# Create the Termination passthrough route
oc create route passthrough <name> --service=<svc-name> --hostname=<url>
```

## Taints and Tolerations

* Taint and Toleration are not related to security
* Taints and tolerations allow the node to control which pods should (or should not) be scheduled on them.
* Taint will be applied on **NODE**
* Tolerations will be applied on **POD**

| Effect           | Block new pods | Remove existing pods | Its required |
| ---------------- | ------------------- | ---------------------- | ------------- |
| NoSchedule       | ✅ Yes               | ❌ No                  | ✅ Yes         |
| PreferNoSchedule | ⚠️ Try to avoid     | ❌ No                  | ❌ No         |
| NoExecute        | ✅ Yes               | ✅ Yes                  | ✅ Yes         |


Taints on NODE

```bash
oc adm taint nodes <node> <key>=<value>:<effect>

oc adm taint nodes node1 key1=value1:NoExecute

# Effect - NoSchedule / PreferNoSchedule / NoExecute
```

Toleration on Pod

```yaml
# path `oc explain pod.spec.tolerations`
tolerations:
- key: "key1"
  operator: "Exists"
  effect: "NoExecute"
  tolerationsSecondes: 3600
```

```bash
# Check if node has taint
oc describe nodes <node> | grep Taints
```

## Troubleshooting

```bash
# Check if a node has taint
oc describe node <node> | grep Taints
```

```bash
# Check for endpoints
oc get endpoints
```

```bash
# Check service info
oc describe svc <svc>
```

```bash
# Test MYSQL or MARIADB database connection
mysql -h <host> -P <port> -u <user> -p
```

## Scale & Autoscale

```bash
# Create a autoscale for a resource
oc autoscale deploy/<deploy> --name <name> --min=3 --max=10 --cpu-percent=60
```


