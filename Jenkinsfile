pipeline {
    agent any
    stages {
        stage('Build') {
                steps {
                sh 'bash --login'
                sh 'bundle install'
                }
            }
        stage('Test') {
            steps {
                nodejs('node') {

                    sh 'rspec '
                }
                junit 'spec/reports/*.xml'
            }
        }
    }
}