# Downstream Post-Install Scope

This file captures what the legacy post phase did in:
`homelab-setup/provision/terraform/kubernetes/clusters/rancher_user/2_user_post`

## Core behaviors to carry into a dedicated post module

1. Read secrets from Vault:
- Downstream kubeconfig secret (`vault-kubeconfig-path`)
- Rancher management token secret (`vault-cluster-autoscaler-path`)

2. Parse kubeconfig and derive runtime values:
- Downstream API host, CA cert, token
- Management API host and CA cert

3. Configure providers against downstream cluster:
- kubernetes
- kubectl
- helm
- minio
- rancher2 (against management Rancher)

4. Configure cluster-autoscaler integration:
- Create `kube-system/cluster-autoscaler-cloud-config` secret
- Create `kube-system/ca-cert` config map with management CA cert

5. Storage integration:
- Longhorn backup integration has been intentionally removed.
- Future direction is Ceph storage class integration from Proxmox setup.

6. Configure Vault PKI + k8s auth for downstream cluster:
- Create per-cluster PKI role
- Create policy `pki-<cluster>`
- Enable/auth backend path `kubernetes/downstream_k8s/<cluster>`
- Create and read service-account token secret in `cluster-services`
- Configure `vault_kubernetes_auth_backend_config`
- Configure `vault_kubernetes_auth_backend_role`

7. Apply cert-manager cluster issuer manifest:
- Apply templated `cluster-issuer.yaml.tmpl` using `kubectl_manifest`

## Notable legacy constraints

- State backend was S3-compatible MinIO with fixed key `user_post.tfstate`.
- Some files existed but were disabled (`*.tf.disabled`) and not active in the normal run.

## Recommended new repo split

- `modules/downstream-post-core`
  - Vault reads, kubeconfig parsing, provider wiring.
- `modules/downstream-post-autoscaler`
  - `cluster-autoscaler-cloud-config` + CA config map.
- `modules/downstream-post-storage`
  - Reserved for future Ceph storage class integration.
- `modules/downstream-post-vault-auth`
  - PKI role/policy + k8s auth backend and role.
- `modules/downstream-post-certmanager`
  - ClusterIssuer manifest and template files.

Keep Terragrunt units thin and use stack ordering for orchestration.
