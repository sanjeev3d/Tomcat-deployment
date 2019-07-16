provider "google" {
	credentials = "${file("${var.gcloud_secret_access_key}")}"
	project = "annular-beacon-238207"
	region = "asia-south1"
}