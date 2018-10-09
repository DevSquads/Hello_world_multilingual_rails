# Hello World Multi-lingual 

This project aims to practise multilingual setup for rails web app

## To start running tests using docker
* install docker ( Mac https://download.docker.com/mac/stable/Docker.dmg )
* run & build the docker images
`docker-compose up --build `
This will run the docker in Test mode for CI

## To start developing docker
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
https://www.ruby-lang.org/en/documentation/installation/
* install rails 5.2.1
https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rvm-on-ubuntu-16-04
* install postgresql
* change the config/database.yml for pg user 
* run `bundle install`
* run the app `rails s`
* run the tests `rspec`