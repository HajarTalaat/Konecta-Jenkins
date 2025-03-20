pipeline {
    agent any

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'feature-webapp', url: 'https://github.com/your-repo.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t my-web-app .'
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    sh 'docker stop web-container || true'
                    sh 'docker rm web-container || true'
                    sh 'docker run -d -p 80:80 --name web-container my-web-app'
                }
            }
        }
    }
}
