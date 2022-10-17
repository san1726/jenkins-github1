pipeline{
   agent any
   options {
       buildDiscarder(logRotator(numToKeepStr: "10"))
       disableConcurrentBuilds()   
   }
   
   parameters{
    choice( choices: ["copy", "status-check"], description: "Select required action !", name: "REQUESTED_ACTION")
    string(name: "GIT_BRANCH_TAG", defaultValue: "main", description: "hai..")
   
   }
   environment{
    ZYLER_GIT_REPO = "git@github.com:san1726/jenkins-github1.git"
    ZYLER_BRANCH = "${params.ZYLER_BRANCH_TAG}"
    REPO_CRED = "jenkins-id"
    REQUESTED_ACTION = "${params.REQUESTED_ACTION}"
       }
   
   stages {
   
     stage ("Checkout"){
        when {
                expression {
                   return  REQUESTED_ACTION == 'copy'
                }
        }
        steps{
          script{
                sh """
                echo "${ZYLER_GIT_REPO}"
                echo "${ZYLER_BRANCH}"
                echo "${REPO_CRED}"
                
                """
                
               currentBuild.description = "Pipeline execution of Zyler"
               checkout([$class: 'GitSCM', branches: [[name: "${ZYLER_BRANCH}"]], extensions: [], userRemoteConfigs: [[credentialsId: "${REPO_CRED}", url: "${ZYLER_GIT_REPO}"]]])
          
          }
        
        }
     
     }
stage ("copy files"){
        when {
                expression {
                   return  REQUESTED_ACTION == 'copy'
                }
            }       
        steps{
              script{          
                sh '''
                
                 
                 cd jenkins-github1/script-copy;
                 chmod +x copy-test.sh
                 ./copy-test.sh



              
               '''
             echo "copied"
             }
        
         }
     
     }
     
     
       stage ("status-check"){
        when {
                expression {
                   return  REQUESTED_ACTION == 'status-check'
                }
            }       
        steps{
              script{          
                sh '''
                
            df -h             
                                
               '''
             echo "see status"
             }
        
         }
     
     }
