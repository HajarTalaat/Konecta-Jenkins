pipeline {
    agent any

    environment {
        IMAGE_NAME = "myapp"
        REGISTRY = "myregistry.com"
        PROD_SERVER = "44.210.109.63"
        SSH_KEY = "/var/jenkins_home/terraform-key.pem"
    }

    triggers {
        githubPush() // Trigger on any push
    }

    stages {
        stage('Build Docker Image') {
            steps {
                sh "docker build -t $REGISTRY/$IMAGE_NAME:latest ."
            }
        }

        stage('Push to Registry') {
            steps {
                sh "docker push $REGISTRY/$IMAGE_NAME:latest"
            }
        }

        stage('Deploy to Production') {
            steps {
                sshagent(credentials: ['ssh-key']) {
                    sh """
                    ssh -o StrictHostKeyChecking=no -i $SSH_KEY ubuntu@$PROD_SERVER <<EOF
                    docker pull $REGISTRY/$IMAGE_NAME:latest
                    docker stop myapp || true
                    docker rm myapp || true
                    docker run -d --name myapp -p 80:5000 $REGISTRY/$IMAGE_NAME:latest
                    EOF
                    """
                }
            }
        }
    }

    post {
        success {
            echo 'Deployment successful!'
        }
        failure {
            echo 'Deployment failed!'
        }
    }
}
