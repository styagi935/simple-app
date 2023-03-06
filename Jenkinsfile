pipeline {
    agent any
    environment {
    PATH = "/opt/apache-maven-3.8.7/bin/:$PATH"
    DOCKERHUB_CREDENTIALS = credentials('DockerHub')
    //Get the Latest tag
    DOCKER_TAG = getDockerTag()
    
     }
    stages{
        stage('Git CheckOut'){
            steps{
                git 'https://github.com/ankupsatpute/simple-app.git'     
                //echo "$BUILD_TRIGGER_BY"
               }
            }
        
        stage('Maven Build'){
           steps{
               sh 'mvn clean package'
                 }
               }
        
        stage('Docker Build'){
            steps{
                 sh " docker build . -t ankushsatpute/ankush:${DOCKER_TAG}"
               }
             }
          
         stage ('Docker Image Push'){
            steps{
                sh "echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin"
                sh "docker push ankushsatpute/ankush:${DOCKER_TAG}"
                sh "docker rmi ankushsatpute/ankush:${DOCKER_TAG}"
                
                }
             }
          
          stage('Deploy On EKS'){
             steps{ 
                  // withKubeCredentials(kubectlCredentials: [[caCertificate: '', clusterName: '', contextName: '', credentialsId: 'K8S', namespace: '', serverUrl: '']])
                withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'EKS', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                     sh "chmod +x changeTag.sh"
                     sh "./changeTag.sh ${DOCKER_TAG}"   
                     sh "kubectl apply -f pods.yml"
                     sh "kubectl apply -f service.yml"
  
                        }           
                }
            }
          
    }
}
def getDockerTag(){
    def tag = sh script: 'git rev-parse HEAD', returnStdout: true
    return tag
}
