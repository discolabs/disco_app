#!/bin/bash
# Usage: initialise.sh example_app

APP_NAME="$1"
RAILS_VERSION="${RAILS_VERSION:-6.0.1}"
RUBY_VERSION="${RUBY_VERSION:-2.6.5}"
DISCO_APP_VERSION="${DISCO_APP_VERSION:-0.18.0}"

if [ -z $APP_NAME ]; then
  echo "Usage: ./initialise.sh app_name (rails_version) (ruby_version) (disco_app_version)"
  echo "Only app_name is required, defaults to Rails $RAILS_VERSION, Ruby $RUBY_VERSION, Disco App $DISCO_APP_VERSION."
  exit
fi

mkdir $APP_NAME
cd $APP_NAME
echo "source 'https://rubygems.org'" > Gemfile
echo "gem 'rails', '~> $RAILS_VERSION'" >> Gemfile
echo "ruby $RUBY_VERSION" > .tool-versions
bundle install
bundle exec rails _"$RAILS_VERSION"_ new . --force --skip-bundle
echo "gem 'disco_app', '$DISCO_APP_VERSION', source: \"https://gem.fury.io/discolabs/\"" >> Gemfile
bundle update
bundle exec rails generate disco_app:install --force
