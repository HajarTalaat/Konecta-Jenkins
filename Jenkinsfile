pipeline {
    agent any

    environment {
        IMAGE_NAME = "myapp:latest"
        REGISTRY = "my-private-registry.com"
        PRODUCTION_SERVER = "ubuntu@<Production-Server-IP>"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $REGISTRY/$IMAGE_NAME .'
                }
            }
        }

        stage('Push to Private Registry') {
            steps {
                script {
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASSWORD $REGISTRY'
                    sh 'docker push $REGISTRY/$IMAGE_NAME'
                }
            }
        }

        stage('Deploy on Production') {
            steps {
                script {
                    sshagent(['jenkins-prod-key']) {
                        sh '''
                        ssh -o StrictHostKeyChecking=no $PRODUCTION_SERVER <<EOF
                        docker pull $REGISTRY/$IMAGE_NAME
                        docker stop myapp || true
                        docker rm myapp || true
                        docker run -d --name myapp -p 80:80 $REGISTRY/$IMAGE_NAME
                        EOF
                        '''
                    }
                }
            }
        }
    }

    triggers {
        githubPush()
    }
}
