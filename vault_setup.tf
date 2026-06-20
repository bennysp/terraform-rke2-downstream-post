resource "vault_pki_secret_backend_role" "role" {
  backend          = var.vault_pki_path
  name             = local.cluster_name_effective
  max_ttl          = 259200
  allow_ip_sans    = true
  allow_subdomains = true
  allowed_domains  = [var.vault_pki_domain]
  ou               = [var.vault_pki_ou]
  organization     = [var.vault_pki_organization]
  country          = [var.vault_pki_country]
  locality         = [var.vault_pki_city]
  province         = [var.vault_pki_state]
  street_address   = [var.vault_pki_address]
  postal_code      = [var.vault_pki_zip]
}

resource "vault_policy" "vault_pki_policy" {
  name = "pki-${local.cluster_name_effective}"

  policy = <<EOT
path "pki*"                                        { capabilities = ["read", "list"] }
path "pki/roles/${local.cluster_name_effective}"   { capabilities = ["create", "update"] }
path "pki/sign/${local.cluster_name_effective}"    { capabilities = ["create", "update"] }
path "pki/issue/${local.cluster_name_effective}"   { capabilities = ["create"] }
path "secret*"                                     { capabilities = ["read", "list", "create", "update"] }
EOT
}

resource "vault_auth_backend" "vault_auth_k8s" {
  type = "kubernetes"
  path = "kubernetes/downstream_k8s/${local.cluster_name_effective}"
}

resource "kubernetes_secret" "vault_k8s_sa_token" {
  metadata {
    annotations = {
      "kubernetes.io/service-account.name" = var.k8s_sa_vault
    }
    name      = var.k8s_sa_vault
    namespace = var.vault_ns
  }

  type                           = "kubernetes.io/service-account-token"
  wait_for_service_account_token = true
}

data "kubernetes_secret" "vault_helm_secret_name" {
  depends_on = [kubernetes_secret.vault_k8s_sa_token]

  metadata {
    name      = var.k8s_sa_vault
    namespace = var.vault_ns
  }
}

locals {
  k8s_token_jwt = nonsensitive(data.kubernetes_secret.vault_helm_secret_name.data.token)
}

resource "vault_kubernetes_auth_backend_config" "vault_auth_config" {
  backend                = vault_auth_backend.vault_auth_k8s.path
  kubernetes_host        = local.k8s_host
  kubernetes_ca_cert     = local.k8s_ca
  token_reviewer_jwt     = local.k8s_token_jwt
  issuer                 = "https://kubernetes.default.svc.cluster.local"
  disable_iss_validation = true
}

resource "vault_kubernetes_auth_backend_role" "vault_auth_role" {
  backend                          = vault_auth_backend.vault_auth_k8s.path
  role_name                        = local.cluster_name_effective
  bound_service_account_names      = [var.k8s_sa_vault]
  bound_service_account_namespaces = [var.vault_ns]
  token_ttl                        = 86400
  token_policies                   = [vault_policy.vault_pki_policy.name]
}
