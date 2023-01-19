pipeline {
    agent any
    environment {
    PATH = "/opt/apache-maven-3.8.7/bin:$PATH" 
    def junit = '**/target/surefire-reports/TEST-*.xml'
    }
    stages{
        stage('Cleanup Workspace') {
            steps {
                cleanWs()
                sh """
                echo "Cleaned Up Workspace For Project"
                """
            }
        }
        
       stage('Git CheckOut'){
            steps{
              git branch: '$BRANCH_NAME', changelog: false, poll: false, url: 'https://github.com/ankupsatpute/simple-app-final.git'
               echo "Git Checkout Completed"            
               }
            }
        
        
         stage('OWASP-Dependency-Check'){
             when{
                 branch 'UAT'
             }
           steps{
                dependencyCheck additionalArguments: '--scan $WORKSPACE/ --format ALL --disableYarnAudit', odcInstallation: 'OWASP-Dependency-Check' 
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml', unstableNewCritical: 1, unstableNewHigh: 2, unstableTotalCritical: 1, unstableTotalHigh: 2
            }
        }  
        
     stage('Unit Test'){
                steps{
                    sh 'mvn test'
                }
            }
        
         stage('Maven Build'){
               steps{
                    sh 'mvn clean package'
                }  
            }
        
        stage('Check Code Coverage'){
             steps{
                    junit "${env.junit}"
                    echo 'The Junit is Sucessfull'
                    jacoco ()
                    echo 'The Code Coverage is Sucessfull'
                   echo "Current workspace is $WORKSPACE"
                 }
            }
            
        /*stage('Code Analysis With SonarQube'){
              when{
              branch 'develop'
              }
               steps{
                withSonarQubeEnv('sonarqube-8.9.10.61524'){
                    sh'mvn sonar:sonar -Dsonar.projectKey=Ansible'
                    
                }
               }
            }*/
        
        stage ('Deploy_Develop'){
                when {
                    branch 'develop'
                }
            steps{
                sshagent(['Tomcat']) {
                sh "scp -o StrictHostkeyChecking=no  $WORKSPACE/target/*.war ec2-user@172.31.7.56:/opt/apache-tomcat-9.0.70/webapps"
                     }
                   }
              }
        
        stage ('Deploy_UAT'){
              when {
                  branch 'UAT'
                }
            steps{
                sshagent(['Tomcat']) {
                sh "scp -o StrictHostkeyChecking=no  $WORKSPACE/target/*.war ec2-user@172.31.14.112:/opt/apache-tomcat-9.0.70/webapps"
                 }
             }
         }
        
        /* stage('DAST'){
             when {
                    branch 'UAT'
                }
          steps{
           sh "docker run -t owasp/zap2docker-stable zap-baseline.py -t http://65.1.3.193:8080/simple-app-1.0.0|| true"
          }
          post{
              always{
                  sh 'docker rm $(docker ps --filter status=exited -q)'
              }
          }

       }*/
        
        stage ('Deploy_Release'){
              when {
                  branch 'release'
                }
            steps{
                sshagent(['Tomcat']) {
                sh "scp -o StrictHostkeyChecking=no  $WORKSPACE/target/*.war ec2-user@172.31.46.102:/opt/apache-tomcat-9.0.71/webapps"
                 }
             }
         }
        
       /*stage('DAST'){
             when {
                    branch 'release'
                }
          steps{
           sh "docker run -t owasp/zap2docker-stable zap-baseline.py -t http://65.1.3.193:8080/simple-app-1.0.0|| true"
          }
          post{
              always{
                  sh 'docker rm $(docker ps --filter status=exited -q)'
              }
          }

       }*/
   }
}
