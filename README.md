# DiscoApp Rails Engine
A Rails Engine encapsulating common (boilerplate) functionality for Disco's
Shopify applications.

Aims to make getting a new Shopify application set up and running as quickly
and as easily as possible, as well as collecting useful patterns for Shopify
apps in a single codebase.

This document is split into the following sections:

- [Getting Started](#getting-started)
- [Engine Overview](#engine-overview)
- [Contributing](#contributing)


## Getting Started
Spinning up a new Shopify app with this engine is a simple three-step process,
detailed below. A short screencast running through this process is available
([View screencast][]).

[View screencast]: #

### 1. Setting up
First make sure you've got all of the tools you need for Shopify and Rails
development. You should read through the [General Development][] and
[Rails Development][] sections on the Disco documentation site. The key things
to note are:

- You should have set up a Shopify Partner account to allow you to create
  development stores and applications;
- [rbenv][] is recommended for Ruby version management;
- You should have the latest version of Ruby 2.2 installed locally, along with
  the `rails` and `bundler` gems;
- You should have some form of HTTP tunnelling software like [ngrok][] or
  [localtunnel][] installed.

[General Development]: https://github.com/discolabs/docs/blob/master/sections/development.md#general-development
[Rails Development]: https://github.com/discolabs/docs/blob/master/sections/development.md#rails-development
[rbenv]: https://github.com/sstephenson/rbenv
[ngrok]: https://ngrok.com
[localtunnel]: http://localtunnel.me

### 2. Creating the Rails app
Running the following commands from your terminal to create a new Rails app,
add the DiscoApp Rails Engine to your Gemfile, and run the engine setup:

```
$ export DISCO_GEM_CREDENTIALS=disco-gems:f361b0fef05c465c85a3d2d297930719617cb583
$ rails new example_app
$ cd example_app
$ echo "gem 'disco_app', git: 'https://$DISCO_GEM_CREDENTIALS@github.com/discolabs/disco_app.git'" >> Gemfile
$ bundle install
$ rails generate disco_app --force
$ bundle install
```

Once this is complete, you'll have a new Rails app created in `/example_app`,
with the DiscoApp engine configured and mounted.

### 3. Setting up the Shopify app
In order to work on our app, we need to create a development application from
the Shopify Partners dashboard. Once that's done, we can copy across the
generated API credentials to our development app and test the installation of
our app into a development store.

To do this, open your Shopify Partner dashboard and create a new application
from the "Apps" tab. Make sure the "Embedded App" option is selected. When
prompted for the callback URL, enter the endpoint provided by your tunneling
software - for example, `https://example.ngrok.io`.

Once the application has been created on Shopify, copy over the API credentials
to the `SHOPIFY_APP_API_KEY` and `SHOPIFY_APP_SECRET` values in the `.env` file
created by the DiscoApp generator in step 2 and located in the root directory
of the Rails app.

While the `.env` file is open, add in values for `DEFAULT_HOST` (this should be
the tunnel endpoint) and `SHOPIFY_APP_API_SCOPE` (view a [list of scopes][]).
The `SECRET_KEY_BASE` and `REDIS_PROVIDER` values can be left blank in
development.

[list of scopes][]: https://docs.shopify.com/api/authentication/oauth#scopes

### 4. Putting it all together


## Engine Overview


## Contributing