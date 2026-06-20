variable "cluster_name" {
  description = "Logical downstream cluster name."
  type        = string
  default     = "rancher-cluster"
}

variable "clustername" {
  description = "Legacy downstream cluster name input."
  type        = string
  default     = ""
}

variable "kubeconfig_location" {
  description = "Kubeconfig location produced by downstream provision phase."
  type        = string
  default     = "~/.kube/config.downstream"
}

variable "vault_kubeconfig_secret_path" {
  description = "Vault path containing downstream kubeconfig."
  type        = string
  default     = "secret/kubernetes/downstream/default/k8sconfig"
}

variable "vault_cluster_autoscaler_path" {
  description = "Vault path containing downstream cluster-autoscaler token."
  type        = string
  default     = "secret/kubernetes/downstream/default/token"
}

variable "vault_ns" {
  type    = string
  default = "cluster-services"
}

variable "vault_dns" {
  type    = string
  default = "vault.domain.thedaily.tv"
}

variable "vault_pki_path" {
  type    = string
  default = "pki"
}

variable "vault_pki_domain" {
  type    = string
  default = "k8s.thedaily.tv"
}

variable "vault_pki_ou" {
  type    = string
  default = "PTMIL"
}

variable "vault_pki_organization" {
  type    = string
  default = "PTMIL"
}

variable "vault_pki_country" {
  type    = string
  default = "US"
}

variable "vault_pki_city" {
  type    = string
  default = "Eagan"
}

variable "vault_pki_state" {
  type    = string
  default = "MN"
}

variable "vault_pki_address" {
  type    = string
  default = "NA"
}

variable "vault_pki_zip" {
  type    = string
  default = "55122"
}

variable "k8s_sa_vault" {
  type    = string
  default = "vault"
}

variable "enable_cluster_autoscaler" {
  description = "Enable downstream cluster-autoscaler post configuration."
  type        = bool
  default     = true
}
