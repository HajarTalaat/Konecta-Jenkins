pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "your-private-registry.com/your-app-image:latest"
        PRODUCTION_SERVER = "ubuntu@<PRODUCTION_SERVER_IP>"
    }

    triggers {
        githubPush()
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${DOCKER_IMAGE} ."
                }
            }
        }

        stage('Push to Private Registry') {
            steps {
                script {
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                sshagent(['jenkins-prod-key']) {
                    sh """
                        ssh -o StrictHostKeyChecking=no ${PRODUCTION_SERVER} '
                        docker pull ${DOCKER_IMAGE} &&
                        docker stop my-container || true &&
                        docker rm my-container || true &&
                        docker run -d --name my-container -p 80:80 ${DOCKER_IMAGE}'
                    """
                }
            }
        }
    }
    
    post {
        failure {
            echo "❌ Deployment failed! Check the logs."
        }
        success {
            echo "✅ Deployment successful!"
        }
    }
}
