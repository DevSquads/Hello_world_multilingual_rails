pipeline {
    agent any
    stages {
        stage('Build') {
                steps {
                sh '/usr/local/rvm/rubies/ruby-2.5.1/lib/ruby/gems/2.5.0/bin/bundle install'
                }
            }
        stage('Test') {
            steps {
                nodejs('node') {
                    sh '/usr/local/rvm/gems/ruby-2.5.1/bin/rspec --format RspecJunitFormatter  --out spec/reports/result.xml'
                }
                junit 'spec/reports/*.xml'
            }
        }
    }
}