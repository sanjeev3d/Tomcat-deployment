import hudson.Util;
def label = "worker-${UUID.randomUUID().toString()}"
podTemplate(label: label, containers: [
  containerTemplate(name: 'terraform', image: 'hashicorp/terraform', command: 'cat', ttyEnabled: true),
  ],
  volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {
	try{
		node(label){
			stage('Initialize workspace'){
				deleteDir()
			}
			gitrepo = checkout scm
			gitCommit = gitrepo.GIT_COMMIT
			gitBranch = gitrepo.GIT_BRANCH
			stage('Infra Build'){
				try {
					container('terraform'){
						withCredentials([file(credentialsId: 'gcloud-credential', variable: 'GCLOUDSECRETACCESSKEY')]){
						sh """
							terraform init
							terraform plan
							terraform apply -auto-approve
							"""
						}
					}
				}
				catch( exc ) {
     				error "Terraform Failure"
     				throw(exc)
     			}
			}
			stage('Deploy Helm'){
				try {
					sh """
						kubectl apply -f ./

					
				}
				catch(Exception e) {
					
				}
				
			}
		}