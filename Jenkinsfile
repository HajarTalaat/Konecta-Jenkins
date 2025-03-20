pipeline {
    agent any

    environment {
        REGISTRY = "your-private-registry.com"
        IMAGE_NAME = "your-app-image"
        IMAGE_TAG = "latest"
        PROD_SERVER = "ubuntu@<PRODUCTION_SERVER_IP>"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    echo "🔨 Building Docker Image..."
                    sh "docker build -t ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push to Private Registry') {
            steps {
                script {
                    echo "📤 Pushing Image to Registry..."
                    sh "docker login -u YOUR_USERNAME -p YOUR_PASSWORD ${REGISTRY}"
                    sh "docker push ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                sshagent(['jenkins-prod-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no ${PROD_SERVER} '
                        docker login -u YOUR_USERNAME -p YOUR_PASSWORD ${REGISTRY} &&
                        docker pull ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG} &&
                        docker stop ${IMAGE_NAME} || true &&
                        docker rm ${IMAGE_NAME} || true &&
                        docker run -d -p 80:80 --name ${IMAGE_NAME} ${REGISTRY}/${IMAGE_NAME}:${IMAGE_TAG}
                    '
                    """
                }
            }
        }
    }

    triggers {
        githubPush() // Triggers on every push
    }
}
