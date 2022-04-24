pipeline {
    environment {
        registry = '956071277379.dkr.ecr.us-east-1.amazonaws.com'
    }
    agent any
    stages {
        stage('Repo Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/gmkmanoj/upgrad-devops.git'
            }
        }
        stage('Build image') {
            steps {
                script {
                    app_build_number = docker.build(registry + "/upgrad-app:$BUILD_NUMBER")
                    app_latest = docker.build(registry + '/upgrad-app:latest')
                }
            }
        }
        stage('Push image') {
        steps {

       sh(label: 'ECR login and docker push', script:
         '''
         #!/bin/bash
         
           echo "Authenticate with ECR"
            set +x # Don't echo credentials from the login command!
            echo "Building New ECR Image"
            aws ecr get-login-password | docker login --password-stdin --username AWS https://$registry
            # Enable Debug and Exit immediately 
            set -xe
            docker push $registry/upgrad-app:latest
         '''.stripIndent())
                }
            }
            
        stage('Deploy image') {
            steps {
                    sh 'ssh -o StrictHostKeyChecking=no -l ubuntu appserver "aws ecr get-login-password | sudo docker login --password-stdin --username AWS https://$registry || ture && sudo docker stop app-server || true && sudo docker rm app-server || true && sudo docker system prune -af || true && sudo docker run -p 8080:8081 --name app-server -d ' + registry + '/upgrad-app:latest"'
            }
        } 
    }
}
