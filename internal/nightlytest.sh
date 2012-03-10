#!/bin/bash
# Script to pull, build, and run tests on the repo and send an email
# to the team with the results (indicating either script failure or
# the results of the test
#
# To run nightly, use the following crontab entry:
# 0 0 * * * /path/to/script
#
# Author:: Tyler Rigsby

EMAILS="aimlessrose@gmail.com,alexmiller@gmail.com,tjrigs@gmail.com,harnoor28@gmail.com,brettw07@gmail.com,djmailhot@gmail.com"
DATE=`date +%D`
SUBJECT=$DATE":BeatTide_Daily_Test_Results"
RAILS_ENV=test; source /home/serverman/.rvm/scripts/rvm;
REPO_PATH="/home/serverman/beattide"

# error function emails the team with the specified source of the error
function error_exit
{
    echo "$1" | mail -s $DATE":BeatTide_build_server_failure" $EMAILS 
    exit 1
}

# pull, migrate the test db, install any new gems, and run the tests.
# email the team of the results
cd $REPO_PATH
git pull origin master
if [ "$?" != "0" ]; then
    error_exit "build server git pull failure"
fi
bundle exec rake db:migrate
if [ "$?" != "0" ]; then
    error_exit "build server test database migration failure"
fi
bundle install
if [ "$?" != "0" ]; then
    error_exit "build server bundle install failure"
fi
bundle exec rspec spec/ | mail -s "'"$SUBJECT"'" $EMAILS

exit 0