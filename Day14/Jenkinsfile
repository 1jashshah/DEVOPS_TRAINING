pipeline {
    agent any
    stages {
        stage('Clone Repository') {
            steps {
                git url:'https://github.com/1jashshah/Jenkins-java-docker-DAY13th-.git', branch: 'main'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t 1jashshah/day14th'
            }
        }
        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dockerid')]) {
                    sh 'docker login'
                    sh 'docker push 1jashshah/day14th'
                }
            }
        }
        stage('Deploy Container') {
            steps {
                sh 'docker run -d -p 8089:8080 1jashshah/day14th'
            }
        }
    }
}
