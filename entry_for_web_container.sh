#!/bin/sh
# entry_for_web_container.sh

if  $RAILS_CI ; then
    ./wait-for-postgres.sh postgdb 5432
    bundle exec rails s -d -p 3000 -b '0.0.0.0'
    /usr/bin/xvfb-daemon-run
    rspec --format RspecJunitFormatter  --out spec/reports/result.xml
else
    ./wait-for-postgres.sh postgdb 5432
    bundle exec rails s  -p 3000 -b '0.0.0.0'
    /usr/bin/xvfb-daemon-run
fi