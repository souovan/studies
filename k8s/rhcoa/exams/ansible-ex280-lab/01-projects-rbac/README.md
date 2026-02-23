# EX280 Simulation - Projects and RBAC

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