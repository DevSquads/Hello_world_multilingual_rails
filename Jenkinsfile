pipeline {
    agent any
    stages {
        stage('clean Docker compose') {
            steps {
                sh 'docker-compose down'
            }
        }
        stage('Test') {
            steps {
                sh 'docker-compose up -d'
                sleep 90
                junit 'spec/reports/*.xml'
            }
        }
    }
}