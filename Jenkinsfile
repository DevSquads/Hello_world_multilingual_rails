pipeline {
    agent { 
        docker { label 'docker'} 
    }
    stages {
        stage('clean Docker compose') {
            steps {
                sh 'docker-compose down'
            }
        }
        stage('Test') {
            steps {
                sh 'docker-compose up -d'
                sleep 20
                junit 'spec/reports/*.xml'
            }
        }
    }
}