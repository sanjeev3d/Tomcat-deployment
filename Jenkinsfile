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
			try{
			stage('Initialize workspace'){
				deleteDir()
			}
			gitrepo = checkout scm
			gitCommit = gitrepo.GIT_COMMIT
			gitBranch = gitrepo.GIT_BRANCH
			stage('Infra Build'){
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
			stage('Deploy Helm'){
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
						"""
							isReleaseExists = sh(script: "helm list -q | tr '\\n' ','", returnStdout: true)
							if (isReleaseExists.contains("tomcat")) {
							sh "helm upgrade tomcat tomcat-helmchart"
							} else {
							sh "helm install -n tomcat tomcat-helmchart"
							}
						}
					}
				}
			} catch(exc) {
				error "Deployment Filed"
			} finally {
			userInput = input(id: "Please_select", message: "want to destroy last deployment", parameters: [[$class: "ChoiceParameterDefinition", choices: "Yes\nNo", name: "Env"]])
			if (userInput == "Yes") {
				stage('Infra Destroy'){
					//try {
						container('terraform'){
							withCredentials([file(credentialsId: 'gcloud-credential', variable: 'GCLOUDSECRETKEY')]){
							sh """
								cd ./infra_build/
								export TF_VAR_gcloud_secret_access_key="${GCLOUDSECRETKEY}"
								terraform init -backend-config="credentials=${GCLOUDSECRETKEY}"
								terraform destroy -auto-approve
								"""
							}
						}
					//}
					//catch( exc ) {
     				//	error "Infra Destroy Failure"
     				//throw(exc)
     				//}
				}
			}
		}
	}
