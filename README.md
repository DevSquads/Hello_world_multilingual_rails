# Hello World Multi-lingual 

This project aims to practise multilingual setup for a rails web app.

## To start running tests using docker
* install docker.
* run & build the docker images
`docker-compose up --build `
This will run the docker in Test mode for CI.
* The test results is shown in spec/reports/result.xml.

## To start developing with docker
* change the environment variable from docker-compose 
      ` RAILS_CI=true`
to
      ` RAILS_CI=false`

* run docker compose using `docker-compose up --build` 
* you can go to http://localhost:3000/
* start docker container `docker exec -it hello_word_multilingual_rails_web_1 bash`
* stop the containers `docker-compose down`

## To start WITHOUT Docker
* install ruby 2.5.1  
* install rails 5.2.1
* install postgresql
* change the config/database.yml for pg user 
* run `bundle install`
* run `rake db:setup`
* run `rake db:migrate`
* run the app `rails s`
* run the tests `rspec`