import hudson.Util;
def label = "worker-${UUID.randomUUID().toString()}"
podTemplate(label: label, containers: [
  containerTemplate(name: 'terraform', image: 'hashicorp/terraform', command: 'cat', ttyEnabled: true),
  containerTemplate(name: 'gcloud-kubectl-helm', image: 'devth/helm', command: 'cat', ttyEnabled: true)
  ],
  volumes: [
  hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
]) {
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
						withCredentials([file(credentialsId: 'gcloud-credential', variable: 'GCLOUDSECRETKEY')]){
						sh """
							cd ./infra_build/
							export TF_VAR_gcloud_secret_access_key="${GCLOUDSECRETKEY}"
							terraform init -backend-config="credentials=${GCLOUDSECRETKEY}"
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
				//try {
					container('gcloud-kubectl-helm'){
					withCredentials([file(credentialsId: 'gcloud-credential', variable: 'GCLOUDSECRETKEY')]){
					sh """
						gcloud auth activate-service-account --key-file ${GCLOUDSECRETKEY}
						gcloud config set project annular-beacon-238207
						gcloud config set container/cluster t1-cluster
						gcloud container clusters get-credentials t1-cluster --zone=asia-south1-c
						kubectl apply -f service-account.yaml
						kubectl apply -f role-binding.yml
						helm init --service-account tiller --upgrade
						helm version
						helm install --name Tomcat tomcat-helmchart	
						"""
					}
				}
				//}
				//catch( exc ) {
     			//	error "Helm deployment failure"
     			//	throw(exc)
     			//}
				
			}
		}
	
}
