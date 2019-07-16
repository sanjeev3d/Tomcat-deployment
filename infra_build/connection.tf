provider "google" {
	credentials = "${file("/home/sanjeev/Downloads/annular-beacon-238207-ebdf9f35db43.json")}"
	project = "annular-beacon-238207"
	region = "asia-south1"
}