# File examples for the EXAM

## Openshift Authentication & Authorization

```yaml
# Sample of oauth configuration
# path `oc explain oauth.spec.identityProviders`
spec:
  identityProviders:
  - htpasswd:
      fileData:
        name: localusers
    mappingMethod: claim
    name: myusers
    type: HTPasswd
```

## Openshift Network 

```yaml
# Sample of deployment to use with route termination passthrough
# To generate the deployment 
oc create deployment todo --image=quay.io/redhattraining/todo-angular:v1.2 --port=8080 --dry-run=client -o yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: todo
  name: todo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: todo
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: todo
    spec:
      containers:
      - image: quay.io/redhattraining/todo-angular:v1.2
        name: todo-angular
        ports:
        - containerPort: 8080
        resources: {}
status: {}
# Append to the deployment, path `oc explain deployment.spec.template.spec.containers.volumeMounts`
  volumeMounts:
  - name: tls-certs
    readOnly: true
    mountPath: /usr/local/etc/ssl/certs
volumes:
- name: tls-certs
  secret:
    secretName: todo-certs
```

## Openshift resources quota/limirange

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
        memory: 100Mi
        cpu: 100m
      min:
        memory: 100Mi
        cpu: 10m
      max:
        memory: 300Mi 
        cpu: 500m
      type: Container
    - min:
        memory: 100Mi
        cpu: 10m
      max:
        memory: 300Mi 
        cpu: 500m
      type: Pod
```

## Openshift Storage

```yaml
# sample pv
apiVersion: v1
kind: PersistentVolume
metadata:
  name: landing-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
  - ReadOnlyMany
  nfs:
    path: /open001
    server: 192.168.50.254
  PersistentVolumeReclaimPolicy: Retain
```

```yaml
# sample pvc
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: landing-pvc
spec:
  accessModes:
  - ReadOnlyMany
  resources:
    requests:
      storage: 1Gi
  storageClassName: nfs2
```

## Openshift security

```yaml
# sample cronjob
apiVersion: batch/v1
kind: CronJob
metadata:
  name: my-job
spec:
  jobTemplate:
    metadata:
      name: my-job
    spec:
      template:
        metadata:
        spec:
          containers:
            - command:
                - /bin/bash
                - -c
                - date; echo "Hello from the kubernetes cluster"
              image: any given in exam
              imagePullPolicy: IfNotPresent
              name: hello
              resources: {}
              terminationMessagePath: /dev/termination-log
              terminationMessagePolicy: File
          dnsPolicy: ClusterFirst
          restartPolicy: OnFailure
          schedulerName: default-scheduler
          securityContext: {}
          terminationGracePeriodSeconds: 30
    schedule: 05 05 2 * *
    successfulJobsHistoryLimit: 14
    suspend: false
    status: {}
```

## Openshift Template

```bash
apiVersion: template.openshift.io/v1
kind: Template
metadata:
  creationTimestamp: null
  name: project-request
objects:
- apiVersion: project.openshift.io/v1
  kind: Project
  metadata:
    annotations:
      openshift.io/description: ${PROJECT_DESCRIPTION}
      openshift.io/display-name: ${PROJECT_DISPLAYNAME}
      openshift.io/requester: ${PROJECT_REQUESTING_USER}
    creationTimestamp: null
    name: ${PROJECT_NAME}
  spec: {}
  status: {}
- apiVersion: rbac.authorization.k8s.io/v1
  kind: RoleBinding
  metadata:
    creationTimestamp: null
    name: admin
    namespace: ${PROJECT_NAME}
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: admin
  subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: ${PROJECT_ADMIN_USER}
- apiVersion: v1
  kind: LimitRange
  metadata:
    name: $(PROJECT_NAME)-mem-limit-range
  spec:
    limits:
      - default:
          memory: 512Mi
        defaultRequest:
          memory: 254Mi
        min:
          memory: 5Mi
        max:
          memory: 1Gi
        type: Container
parameters:
- name: PROJECT_NAME
- name: PROJECT_DISPLAYNAME
- name: PROJECT_DESCRIPTION
- name: PROJECT_ADMIN_USER
- name: PROJECT_REQUESTING_USER
```

```bash
apiVersion: v1
items:
- apiVersion: config.openshift.io/v1
  kind: Project
  metadata:
    name: cluster
  spec:
    projectRequestTemplate:
      name: project-request
kind: List
metadata:
  resourceVersion: ""
```




