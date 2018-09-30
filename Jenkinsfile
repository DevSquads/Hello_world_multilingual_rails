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
                    sh 'rspec --format RspecJunitFormatter  --out spec/reports/result.xml'
                }
                junit 'spec/reports/*.xml'
            }
        }
    }
}