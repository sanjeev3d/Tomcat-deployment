//General Variable

variable "admin_username" {
	type = "string"
	description = "username to authenticte kubernetes master"
}

variable "admin_password" {
	type = "string"
	description = "password to authenticate kubernetes master"
}
variable "gcloud_secret_access_key"


//GCP Variable

variable "gcp_cluster_count" {
	type = "string"
	description = "Number of Node in cluster"
}

variable "cluster_name" {
	type = "string"
	description = "cluster name of GCP cluster"
}

// GCP Outputs
output "gcp_cluster_endpoint" {
    value = "${google_container_cluster.gcp_kubernetes.endpoint}"
}
output "gcp_ssh_command" {
    value = "ssh ${var.admin_username}@${google_container_cluster.gcp_kubernetes.endpoint}"
}
output "gcp_cluster_name" {
    value = "${google_container_cluster.gcp_kubernetes.name}"
}