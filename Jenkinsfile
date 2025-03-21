pipeline { 
    agent any

    environment {
        IMAGE_NAME = "nginx:latest"
        REGISTRY = "https://hub.docker.com/u/hatalaat"
        PROD_SERVER = "ubuntu@34.239.155.77"
        SSH_KEY = "/var/jenkins_home/terraform-key.pem"
    }

    stages {
        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $REGISTRY/$IMAGE_NAME .'
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh 'docker login -u $DOCKER_USER -p $DOCKER_PASSWORD'
                    sh 'docker tag $IMAGE_NAME $REGISTRY/$IMAGE_NAME'
                    sh 'docker push $REGISTRY/$IMAGE_NAME'
                }
            }
        }

        stage('Deploy on Production') {
            steps {
                script {
                    sshagent(['jenkins-prod-key']) {
                        sh '''
                        ssh -o StrictHostKeyChecking=no -i $SSH_KEY $PROD_SERVER <<EOF
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
