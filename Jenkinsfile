pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker_cred') // Docker Hub credentials stored in Jenkins
        DOCKER_IMAGE = 'dheerajkr7866/my-python-app' // Change this to your Docker Hub repository name
        AWS_CREDENTIALS = credentials('aws_cred') // AWS credentials stored in Jenkins
        AWS_REGION = 'us-east-1' // Replace with your AWS region
        CODEDEPLOY_APP_NAME = 'python-app-with-auto-scale' // Replace with your CodeDeploy application name
        DEPLOYMENT_GROUP = '1st-deply-group' // Replace with your CodeDeploy deployment group for Auto Scaling
        GITHUB_REPO = 'https://github.com/dheeraj7866/simple-python-app'
        // GITHUB_COMMIT_ID = 'latest-commit-id-or-branch'
    }

    stages {
        // stage('Clone Repository') {
        //     steps {
        //         // GitHub repository clone with credentials if private
        //         git branch: 'main', url: 'https://github.com/dheeraj7866/simple-python-app' // Replace with your GitHub repo URL
        //     }
        // }
        stage('Get Latest Commit ID') {
            steps {
                script {
                    // Fetch the latest commit ID from the cloned repository
                    GITHUB_COMMIT_ID = sh(script: "git rev-parse HEAD", returnStdout: true).trim()
                    echo "Latest Commit ID: ${GITHUB_COMMIT_ID}"
                }
            }
        }


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
                    echo "pushing done"
                }
            }
        }
 
        stage('Deploy to EC2 via CodeDeploy') {
            steps {
                // Use AWS steps plugin to deploy using GitHub as the source
                echo "GitHub Commit ID: ${GITHUB_COMMIT_ID}"
                echo "hi"

                withAWS(region: "${AWS_REGION}", credentials: 'aws_cred') {
                    script {
                        def deploymentResponse  = createDeployment(
                            gitHubRepository: 'dheeraj7866/simple-python-app', // Replace with your GitHub repo URL
                            gitHubCommitId: "${GITHUB_COMMIT_ID}", // Branch or commit ID to deploy
                            applicationName: 'python-app-with-auto-scale', // AWS CodeDeploy Application Name
                            deploymentGroupName: '1st-deply-group', // AWS CodeDeploy Deployment Group
                            deploymentConfigName: 'CodeDeployDefault.AllAtOnce', // Deployment Configuration (e.g., AllAtOnce)
                            description: 'Deploy from Jenkins via GitHub',
                            waitForCompletion: 'false'
                        )

                        echo "Deployment Response: ${deploymentResponse}"
                        def deploymentId = deploymentResponse?.deploymentId
                        echo "Deployment ID: ${deploymentId}"

                        // Wait for the deployment to complete (optional)
                        // timeout(time: 15, unit: 'MINUTES') {
                        //     awaitDeploymentCompletion(deploymentId: deploymentId)
                        // }
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
