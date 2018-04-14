#!/bin/bash
# Usage: initialise.sh example_app

APP_NAME="$1"
RAILS_VERSION="${2:-5.1}"
RUBY_VERSION="${2:-2.5.0}"
DISCO_APP_VERSION="${3:-0.14.1}"

if [ -z $APP_NAME ]; then
  echo "Usage: ./initialise.sh app_name (rails_version) (ruby_version) (disco_app_version)"
  echo "Only app_name is required, defaults to Rails $RAILS_VERSION, Ruby $RUBY_VERSION, Disco App $DISCO_APP_VERSION."
  exit
fi

mkdir $APP_NAME
cd $APP_NAME
echo "source 'https://rubygems.org'" > Gemfile
echo "gem 'rails', '~> $RAILS_VERSION'" >> Gemfile
echo "$RUBY_VERSION" > .ruby-version
bundle install
bundle exec rails new . --force --skip-bundle
echo "gem 'disco_app', '$DISCO_APP_VERSION', source: \"https://gem.fury.io/discolabs/\"" >> Gemfile
bundle update
bundle exec rails generate disco_app --force
