#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec clockwork config/clock.rb
DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rake db:migrate:reset
