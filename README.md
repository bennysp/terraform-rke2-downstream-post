# terraform-rke2-downstream-post

Terraform modules for Rancher downstream cluster post-configuration.

## Modules

- Root module (`//`)

Terragrunt is intentionally kept as the orchestration layer:

- `terragrunt-units-rancher` wires module inputs/outputs.
- `terragrunt-stacks-rancher` controls ordering and composition.
- `terragrunt-rancher-cluster` provides environment-specific values.

See `POST_INSTALL_SCOPE.md` for the legacy post-phase behavior inventory used to drive migration.