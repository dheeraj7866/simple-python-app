pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker_cred') // Docker Hub credentials stored in Jenkins
        DOCKER_IMAGE = 'dheerajkr7866/my-python-app' // Change this to your Docker Hub repository name
        AWS_CREDENTIALS = credentials('aws_cred') // AWS credentials stored in Jenkins
        AWS_REGION = 'us-east-1' // Replace with your AWS region
        CODEDEPLOY_APPLICATION_NAME = 'python-app' // Replace with your CodeDeploy application name
        CODEDEPLOY_DEPLOYMENT_GROUP = 'python-auto-scaling-deployment-group' // Replace with your CodeDeploy deployment group for Auto Scaling
    }

    stages {
        // stage('Clone Repository') {
        //     steps {
        //         // GitHub repository clone with credentials if private
        //         git branch: 'main', url: 'https://github.com/dheeraj7866/simple-python-app' // Replace with your GitHub repo URL
        //     }
        // }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:latest")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker_cred') {
                        docker.image("${DOCKER_IMAGE}:latest").push()
                    }
                }
            }
        }

        stage('Deploy to AWS Auto Scaling Group') {
            steps {
                script {
                    withCredentials([aws(credentialsId: AWS_CREDENTIALS, region: AWS_REGION)]) {
                        // Create a new CodeDeploy deployment for the Auto Scaling group
                        sh """
                        aws deploy create-deployment \
                            --application-name ${CODEDEPLOY_APPLICATION_NAME} \
                            --deployment-group-name ${CODEDEPLOY_DEPLOYMENT_GROUP} \
                            --deployment-config-name CodeDeployDefault.AllAtOnce \
                            --description "Deploying ${DOCKER_IMAGE}:latest" \
                            --s3-location bucket=my-bucket,key=/deployment.zip,bundleType=zip
                        """
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Docker image built, pushed, and deployed successfully to Auto Scaling group.'
        }
        failure {
            echo 'Pipeline failed.'
        }
    }
}
