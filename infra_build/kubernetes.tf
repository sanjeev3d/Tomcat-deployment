resource "google_container_cluster" "gcp_kubernetes" {
	name = "${var.cluster_name}"
	zone = "asia-south1-c"
	initial_node_count = "${var.gcp_cluster_count}"

master_auth {
	username = "${var.admin_username}"
	password = "${var.admin_password}"
}

node_config {
	oauth_scopes = [
	       "https://www.googleapis.com/auth/compute",
          "https://www.googleapis.com/auth/devstorage.read_only",
          "https://www.googleapis.com/auth/logging.write",
          "https://www.googleapis.com/auth/monitoring",
          "https://www.googleapis.com/auth/cloud-platform"
          ]
          
          tags = ["dev", "work"]
          }
}