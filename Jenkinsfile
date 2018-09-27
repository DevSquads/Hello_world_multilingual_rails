pipeline {
    agent any
    stages {
        stage('Test') {
            steps {
            sh 'rspec --format RspecJunitFormatter  --out spec/reports/result.xml'

            junit 'spec/reports/*.xml'
            }
        }
    }
}