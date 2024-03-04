#!/bin/bash

cd /app

bundle install

bin/rails db:setup
bin/rails db:migrate
bin/rails db:seed

rm -f /app/tmp/pids/server.pid

bin/rails s -b 0.0.0.0
