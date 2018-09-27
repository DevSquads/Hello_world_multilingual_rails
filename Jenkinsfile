pipeline {
    agent any
    stages {
        stage('Build') {
                steps {
                sh 'bundle install'
                }
            }
        stage('Test') {
            steps {
            sh 'rspec --format RspecJunitFormatter  --out spec/reports/result.xml'

            junit 'spec/reports/*.xml'
            }
        }
    }
}