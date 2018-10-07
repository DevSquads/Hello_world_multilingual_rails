#!/bin/sh
# entry_for_web_container.sh
#TODO review the shell script call waitforit from other file

#TODO make rails_CI argument passable
if  $RAILS_CI ; then
    ./wait-for-it.sh postgdb 5432
    bundle exec rails s -d -p 3000 -b '0.0.0.0'
    /usr/bin/xvfb-daemon-run
    rspec --format RspecJunitFormatter  --out spec/reports/result.xml
else
    ./wait-for-it.sh postgdb 5432
    bundle exec rails s  -p 3000 -b '0.0.0.0'
    /usr/bin/xvfb-daemon-run
fi