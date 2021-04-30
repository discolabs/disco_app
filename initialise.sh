#!/bin/bash
# Usage: initialise.sh example_app

# If $RUBY_VERSION version is not set, attempt to get a sane default
# ruby version using whatever is returned by calling 'ruby'
if [ -z "$RUBY_VERSION" ]; then
  RUBY_VERSION=$(ruby -e 'print RUBY_VERSION')
  RUBY_VERSION=${RUBY_VERSION:-2.6.5}
fi
# Now we're settled on a ruby version, check it is installed by switching to it.
. $HOME/.asdf/asdf.sh
asdf shell ruby $RUBY_VERSION
if [ ! $? -eq 0 ]; then
  echo "Attempting to use ruby $RUBY_VERSION but it doesn't appear to be installed."
  echo "You can install it using: asdf install ruby $RUBY_VERSION"
  exit
fi
# Bunlder is also a minimum requirement (within our given ruby environment)
if [ -z $(command -v bundle) ]; then
  echo "Bundler is not installed. You can install it using: gem install bundler"
  exit
fi

APP_NAME="$1"
RAILS_VERSION="${RAILS_VERSION:-6.0.2}"
NODE_VERSION="${NODE_VERSION:-13.7.0}"
DISCO_APP_VERSION="${DISCO_APP_VERSION:-0.18.2}"

if [ -z $APP_NAME ]; then
  echo ''
  echo 'Usage: ./initialise.sh app_name'
  echo ''
  echo 'The app_name parameter is required.'
  echo ''
  echo 'You can override the Ruby, Rails, Node, disco_app versions using the following environment variables, respectively:'
  echo '  $RUBY_VERSION (defaults to '$RUBY_VERSION')'
  echo '  $RAILS_VERSION (defaults to '$RAILS_VERSION')'
  echo '  $NODE_VERSION (defaults to '$NODE_VERSION')'
  echo '  $DISCO_APP_VERSION (defaults to '$DISCO_APP_VERSION')'
  echo ''
  echo 'eg. To specify the rails and node versions:'
  echo ''
  echo 'RAILS_VERSION=5.0.3 NODE_VERSION=10.0.0 ./initialise.sh app_name'
  exit
fi

mkdir $APP_NAME
cd $APP_NAME
echo "source 'https://rubygems.org'" > Gemfile
echo "gem 'rails', '~> $RAILS_VERSION'" >> Gemfile
echo "ruby $RUBY_VERSION" > .tool-versions
echo "nodejs $NODE_VERSION" >> .tool-versions
bundle install
bundle exec rails _"$RAILS_VERSION"_ new . --force
echo "gem 'disco_app', '$DISCO_APP_VERSION', source: \"https://gem.fury.io/discolabs/\"" >> Gemfile
bundle update
bundle exec rails generate disco_app:install --force
