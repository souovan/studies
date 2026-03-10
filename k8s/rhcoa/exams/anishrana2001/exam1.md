### Q1.  Manage Identity Providers:
- configure the Oauth to use HTPasswd as the identity provider.
- Identity Provider name is `ex280-provider`.
- Create 4 users, `harry`, `leader` , `raja`, `qa-engineer` and all should have `review` password.
- Configure  user and apply password for them. Or Ensure that four users account exist.
- Secret name is  `super-secret`
---

# Question 2. Manage Cluster Project and Permissions:
- Create 3 projects, `front-end`, `back-end`, and `app-db`
- `harry` user should have cluster administrator rights.
- `leader` user should be able create project but not administrator tasks or no other user should able to create project.
- `raja` user can only `view` the resources of `front-end` and `back-end` projects.
- `qa-engineer` user should have `admin` access to  `front-end` project.
- `kubaadmin` is  not present  (make sure your cluster-admin user is working fine before delete kubeadmin, otherwise ocp-cluster not recoverable)
---

## Q3.  Create project and assign Role For user

- The `harry` user will create 3 groups, `leaders`, `developers` and `qa`. 
- Add `leader` user in `leaders` group. 
- Add `raja` user in `developers` group. 
- Assign the `qa-engineer` user to the `qa` group.
- Give `edit` permission to `leaders` group members to `back-end` and `app-db` projects.
- Give `view` permission to `qa` group members to `front-end` project.
---

# Question 4. Protect External Traffic with TLS
### Create secure Route  with below information

- Create a secure route in `quart` project.
- Expose application https://souovan.apps-crc.testing
- Generate self sign certificate using given  subject	
- "/C=US/ST=North Carolina/L=Raleigh/O=Red Hat/CN=souovan.apps-crc.testing"
- Note: Service already  created  in any given project you just have to expose  service  with https
- The application should produce the output
---


# Question 5. An application is running on the `red` project. There is one pod running and your task is it must generate the output.


# Question 6. Create a Service Account called `ex280-sa` in a `alpha` project. This project is already created for you.

- There is an application already running.
- ServiceAccoun should be associated with anyuid SCC
---

# Question 7. Deploy application in the project `alpha`:

- There is one pod already running
- Modify the application as is should run with any user as provided by application
- Application should produce output
---


# Question 8. Create secret with named `ex280-secret` in `cloud` project. The key name should be `MYSQL_PASSWORD` and the value of key should be `redhat123`

---
# Question 9. Use the secret `ex280-secret` in project `cloud`
- There is one pod already exist
- It should use ex280-secret secret previously created.
- Application should produce output.
---

# Question 10. Create Resources Quota with below information for project `beta`

- Quota Name is `ex280-quota`
- Maximum  Pods `7` and Service ip `6` and Replication Controller `5` 
- Memory `1G` and cpu core is `1`
--- 

# Question 11. Create LimitRange for project `orange`:

- Set the `pod memory limit` between `5Mi and 300Mi`
- Set the `container memory limit` between `5Mi and 300Mi` and container `default memory request` is `100Mi`
- Set the `pod cpu limit` between `5m and 300m`
- Set the `container cpu limit` between `5m and 300m` and container `default request limit for cpu` is `100m`
---

## Question 12. Scale the single-pod replicas to `5` under the project `tiger` and all pods should run.
---

# Question 13. Configure `Resource Request` & `limits` into deployment and Apply `AutoScale Rule` in the project `scalling`.
- Minimum replicas = 2 , Maximum replicas = 5 and cpu percentage = 50%
- Default request for containers memory should 100Mi and CPU 50m
---

# Question 14. Install an helm chart etherpad from repository https://redhat-cop.github.io/helm-charts in the `mass` project

---

# Question 15. Create a cronjob `test-cron` in the `tiger` project
- `04:05` time
- Every 2 day and every month
- Use image `quay.io/redhattraining/hello-world-nginx:v1.0`
- Use service account and service account name is `ex280-sa`
- Successful job history limit `14`
- Project name should be `tiger`
- Create a cronjob using webconsole or take yaml from documentation
---

# Question 16. Question: create an network policy to connect two pod which are resides in different projects

- First pod is in `network-policy` namespace and second is in `different-namespace` project
- Pod in project `different-namespace` should communicate with `network-policy pod`
- Create an network policy with name `allow-specific`
- Policy uses labels to specify namespace with `network: different-namespace` and for pods selector
- Uses label `env=production`
- Use port `8080/tcp`
- Check the logs of `different-namespace pod` for verification
---

# Question 17. Create PV, PVC and then deployment.

- **Create a pv**
	- Name is tiger-pv
	- Size: `1Gi`
	- Policy: `retain`
	- Mode: `ReadOnlyMany`
- **Create a pvc**
	- Name is `tiger-pvc`
	- Size same as pv
	- Mount pvc to `/usr/share/nginx/html`
	- Project name is `page`
	- Mode same as pv
- **Create an Deployment with**
	- Name of deployment is `tiger`
	- Image is  `quay.io/redhattraining/hello-world-nginx:v1.0`
	- Application uses this link to show output http://nfs-souovan.apps-crc.testing
	- After attaching storage it shows desired output
---


# Question 18. Question: Create an project template with limitrange with container
- minimum memory is 5Mi, max is 1Gi. `defaultrequest` 254 Mi `defaultlimit` is 512 Mi .
- make sure this template available as default request `new-project` template for users.
---

# Question 19. Create a `Liveliness` Health Probe in project `tuesday` which has 1 pod running
- With port `8443`
- Initial delay of `3 sec`
- Time out for the probe is `10 sec`
- Probe must survive atleast `3` crash
---

# Question 20. An application is running on the `chapter1` project. There is one pod running and your task is it must generate the output.

```bash
oc adm taint node $(oc get nodes | awk '{print $1}' | grep -v NAME) datacenter=bsb:NoSchedule
oc new-project chapter1
oc new-app --name webserver-app1 --image quay.io/redhattraining/hello-world-nginx:v1.0 
```

# Question 21. An application is running on the `chapter2` project. There is one pod running and your task is it must generate the output.

```bash
oc new-project chapter2
oc new-app --name webserver-app2 --image quay.io/redhattraining/hello-world-nginx:v1.0
oc expose service webserver-app2 
oc patch service webserver-app2 -n chapter2 --type=json -p='[{"op": "replace", "path": "/spec/selector/deployment", "value": "souovan"}]'
```

# Question 22. An application is running on the `chapter3` project. There is one pod, which is in pending state. Your task is it must generate the output.

```bash
# Prepare the lab
oc new-project chapter3
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
  labels:
    app: webserver-app3
    app.kubernetes.io/component: webserver-app3
    app.kubernetes.io/instance: webserver-app3
  name: webserver-app3
  namespace: chapter3
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      deployment: webserver-app3
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        deployment: webserver-app3
    spec:
      containers:
      - image: quay.io/redhattraining/hello-world-nginx:v1.0
        imagePullPolicy: IfNotPresent
        name: webserver-app3
        ports:
        - containerPort: 8080
          protocol: TCP
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      nodeSelector:
        disktype: ssd
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
EOF
oc expose deployment/webserver-app3
oc expose service webserver-app3
```

# Question 23. An application is running on the `chapter4` project. There is one pod, which is in pending state. Your task is it must generate the output.

```bash
# Prepare the lab
oc new-project chapter4
oc adm taint node $(oc get nodes | awk '{print $1}' | grep -v NAME) datacenter=bsb:NoSchedule
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
  labels:
    app: webserver-app4
    app.kubernetes.io/component: webserver-app4
    app.kubernetes.io/instance: webserver-app4
  name: webserver-app4
  namespace: chapter4
spec:
  progressDeadlineSeconds: 600
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      deployment: webserver-app4
  strategy:
    rollingUpdate:
      maxSurge: 25%
      maxUnavailable: 25%
    type: RollingUpdate
  template:
    metadata:
      labels:
        deployment: webserver-app4
    spec:
      containers:
      - image: quay.io/redhattraining/hello-world-nginx:v1.0
        imagePullPolicy: IfNotPresent
        name: webserver-app4
        ports:
        - containerPort: 8080
          protocol: TCP
        resources: {}
        terminationMessagePath: /dev/termination-log
        terminationMessagePolicy: File
      dnsPolicy: ClusterFirst
      nodeSelector:
        disktype: ssd
      restartPolicy: Always
      schedulerName: default-scheduler
      securityContext: {}
      terminationGracePeriodSeconds: 30
EOF
oc expose deployment/webserver-app4
oc expose service webserver-app4
oc patch service webserver-app4 -n chapter4 --type=json -p='[{"op": "replace", "path": "/spec/selector/deployment", "value": "souovan"}]'
```

# Question 24. An application is running on the `chapter5` project. There is one pod, which is in pending state. Your task is it must generate the output.

```bash
# Prepare the lab
oc new-project chapter5
oc new-app --name webserver-app5 --image quay.io/redhattraining/hello-world-nginx:v1.0
oc patch deployment webserver-app5 -p '{"spec": {"template": {"spec": {"containers": [{"name": "webserver-app5", "resources": {"limits": {"cpu": "2", "memory": "18Gi"}}}]}}}}'
oc delete replicasets.apps $(oc get replicasets.apps | awk '$4~ /1/ {print $1}')
```

# Question 25. Collect Cluster information and create a tar file with name student101-<cluster.id>.tar.gz and send it to redhat support.
- Use command tar cvaf
- One script has been provided to upload tar in redhat support
- /usr/bin/script student101-<cluster.id>.tar.gz
- This script can be performed multiple times and it will overwrite the tar file every time
---

# How to create the lab?

```bash
curl -o /tmp/Openssl-script.sh https://raw.githubusercontent.com/souovan/studies/refs/heads/main/k8s/rhcoa/exams/anishrana2001/answers/Openssl-script.sh
chmod +x /tmp/Openssl-script.sh
# Login with kubeadmin or other cluster-admin user
oc new-project alpha
oc new-app --name gitlab --image quay.io/redhattraining/gitlab-ce:8.4.3-ce.0
oc new-project quart
oc new-app --name todo-http --image quay.io/redhattraining/todo-angular:v1.1
oc expose service todo-http --hostname  server1.apps-crc.testing
oc new-project cloud
oc create deployment mysql-app --image quay.io/redhattraining/mysql-app:v1
oc create secret generic ex280-root --from-literal=MYSQL_USER=redhat --from-literal=MYSQL_DATABASE=world_x
oc set env --from=secret/ex280-root deployment mysql-app
oc new-project tiger
oc new-app --name hello --image quay.io/redhattraining/hello-world-nginx:v1.0
oc new-project scalling
oc new-app --name hello --image quay.io/redhattraining/hello-world-nginx:v1.0
oc new-project network-policy
oc new-app --name hello  --image quay.io/redhattraining/hello-world-nginx:v1.0
oc expose service/hello
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
  ingress: []
  egress: []
EOF
oc new-project different-namespace
oc new-app --name sample-app  --image quay.io/redhattraining/hello-world-nginx:v1.0
oc new-project tuesday
oc new-app --name liveness-deployment  --image quay.io/redhattraining/hello-world-nginx:v1.0
oc new-project orange
oc new-app --name hello --image quay.io/redhattraining/hello-world-nginx:v1.0
```

## To clean the LAB

```bash
oc delete project alpha
oc delete project beta
oc delete project app-db
oc delete project front-end
oc delete project back-end
oc delete project quart
oc delete project cloud
oc delete project tiger
oc delete project scalling
oc delete project network-policy
oc delete project different-namespace
oc delete project tuesday
oc delete project orange
oc delete project page
oc delete project souovan
oc delete project test-pvc
oc delete project nfs-storage
oc delete project mass
oc delete project chapter1
oc delete project chapter2
oc delete project chapter3
oc delete project chapter4
oc delete project chapter5
oc label nodes $(oc get nodes | awk '{print $1}' | grep -v NAME) disktype-
helm repo remove redhat-cop
```
