pipeline{

        agent any

        environment {
                DOCKERHUB_CREDENTIALS=credentials('docker_hub_login')
        }

        stages {

                stage('Build') {

                        steps {
                                sh 'docker build -t nur02/my-image .'
                        }
                }


                stage('Login') {

                        steps {
                            sh 'docker login -p $DOCKERHUB_CREDENTIALS_PSW -u $DOCKERHUB_CREDENTIALS_USR'
                        }
                }

                stage('Push') {

                        steps {
                                sh 'docker push nur02/my-image'
                        }
                }
         
                
                 stage('TestingOnDev') {
                     steps {                       
                        withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                            script {
                                sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker pull nur02/my-image\""
                                try {
                                    sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker stop final1\""
                                    sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker rm final1\""
                                } catch (err) {
                                     echo: 'caught error: $err'
                                }
                                sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$prod_ip \"docker run --restart always --name final1 -p 8088:80 -d nur02/my-image\""
                            }
                        }
                     }
                 }
                
                stage('DeployToProduction') {
                     steps {
                        input 'Deploy to Production?'
                        milestone(1)
                        withCredentials([usernamePassword(credentialsId: 'webserver_login', usernameVariable: 'USERNAME', passwordVariable: 'USERPASS')]) {
                            script {
                                sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$dev_ip \"docker pull nur02/my-image\""
                                try {
                                    sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$dev_ip \"docker stop final22\""
                                    sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$dev_ip \"docker rm final22\""
                                } catch (err) {
                                     echo: 'caught error: $err'
                                }
                                sh "sshpass -p '$USERPASS' -v ssh -o StrictHostKeyChecking=no $USERNAME@$dev_ip \"docker run --restart always --name final22 -p 8088:80 -d nur02/my-image\""
                    }
                }
            }
        }
    }
}