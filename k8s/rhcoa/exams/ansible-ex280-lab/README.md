Ansible playbooks to simulate the EX280 exam

To start

<!-- ```bash
# Get CRC token
oc whoami -t
``` -->

<!-- ```yaml
# configure vars.yaml with
api_url: "https://api.crc.testing:6443"
api_token: "sha256~lfSWFdKMxO5lFHd5bkjY1mRvTCXMHlP1SXG3xSdPbjA"
verify_ssl: false
``` -->

<!-- ```bash
# install 
ansible-galaxy collection install -r requirements.yml
``` -->

> [!IMPORTANT]
>
> The user must be logged in the `oc` CLI

To execute all playbooks

```bash
ansible-playbook 01-projects-rbac/playbook.yaml
ansible-playbook 01-app-deployments/playbook.yaml
ansible-playbook 01-storage/playbook.yaml
ansible-playbook 01-networking/playbook.yaml
ansible-playbook 01-troubleshooting/playbook.yaml
```

To clean the lab

```bash
ansible-playbook reset-lab.yaml
```

## Exame 1

### EX280 Simulation - Application Deployment

Tasks:

1. Fix the deployment image.
2. Expose the application via Service.
3. Create a Route.
4. Scale the deployment to 3 replicas.
5. Configure resource limits.
6. Add environment variable APP_ENV=production.
7. Configure rolling update strategy.


### EX280 Simulation - Networking

Tasks:

1. Allow traffic only from stage-project to prod-project.
2. Expose prod app internally only.
3. Ensure no external access is possible.


### EX280 Simulation - Projects and RBAC

You are required to:

1. Grant developer1 full edit access to dev-project.
2. Allow read-only access in stage-project.
3. Ensure developer1 has no access to prod-project.
4. Create a ServiceAccount named cicd in stage-project.
5. Bind the correct role to cicd to allow deployments.

Validation will check:
- Correct RoleBindings
- Correct ClusterRole usage
- Proper namespace scoping


### EX280 Simulation - Storage

Tasks:

1. Attach the PVC to a deployment.
2. Ensure correct storage size (1Gi).
3. Configure volume mount in /data.
4. Validate persistence after pod restart.


### EX280 Simulation - Troubleshooting

Tasks:

1. Identify why pod is not starting.
2. Fix Security Context Constraint issue.
3. Ensure pod runs as non-root.
4. Verify logs.
5. Make deployment stable.

---
---
