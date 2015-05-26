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
our app to a development store.

To do this, open your Shopify Partner dashboard and create a new application
from the "Apps" tab. Make sure the "Embedded App" option is selected. When
prompted for the callback URL, enter the endpoint provided by your tunneling
software - for example, `https://example.ngrok.io`.

Once the application has been created on Shopify, copy over the API credentials
to the `SHOPIFY_APP_API_KEY` and `SHOPIFY_APP_SECRET` values in the `.env` file
located in the root directory of the Rails app (this was created by the
DiscoApp generator during step 2).

While the `.env` file is open, add in values for `DEFAULT_HOST` (this should be
the tunnel endpoint) and `SHOPIFY_APP_API_SCOPE` (view a [list of scopes][]).
The `SECRET_KEY_BASE` and `REDIS_PROVIDER` values can be left blank in
development.

When you're done, your `.env` file should look something like this:

```
DEFAULT_HOST=https://example.ngrok.io

SHOPIFY_APP_API_KEY=ebef81bcfe2174ff2c6e65f5c0a0ba50
SHOPIFY_APP_SECRET=d5e1347de6352cb778413654e1296dde
SHOPIFY_APP_API_SCOPE=read_products,write_script_tags

SECRET_KEY_BASE=

REDIS_PROVIDER=
```

[list of scopes][]: https://docs.shopify.com/api/authentication/oauth#scopes

### 4. Putting it all together
Finally, we're ready to test the installation of the development app. First,
fire up your tunneling software to proxy requests to port 3000 on your local
machine. For example, if using ngrok:

```
$ ngrok http -subdomain=example 3000
```

In another terminal window, start up the Rails webserver. The DiscoApp
generator provides a Rake task to easily start the server:

```
$ rake start
```

Now you should be able to visit the root URL of your app in the browser (eg
`https://example.ngrok.io`) and be presented with the login screen. Enter the
name of a development Shopify store, and you should be taken through the
process of authorising and installing the application to the store.

If you don't have a development store to test with, you can create on from the
Shopify Partner dashboard in a similar manner to creating a development app.


## Engine Overview
The DiscoApp Rails Engine incorporates and extends the functionality provided
by the ShopifyApp Rails Engine, which is an official gem developed by Shopify.

### Environment and Configuration
DiscoApp sets up a number of Rails configuration choices and conventions.

The following gems are added during setup:

- [shopify_app][] for basic Shopify application functionality;
- [puma][] for serving the app in development and production;
- [sidekiq][] for background job processing in production;
- [pg][] for Postgres use in production;
- [dotenv-rails][] for reading environment variables from `.env` files in
  development;
- [rails_12factor][] for use with Heroku in production.

The following configuration changes are made:

- Force SSL in production;
- Use Sidekiq as the `ActiveJob` queue adapter in production;
- Set the default host in the router to allow absolute URL reversal;

Finally, the following environment changes are made:

- Add `.ruby-version` file and update Gemfile to lock down Ruby version being
  used;
- Add default `.env` and `.env.sample` files for development environment
  management;
- Add a `Procfile` for deployment to Heroku;
- Update the `.gitignore` with some additional useful defaults;
- Add a `start` Rake tasks to spin up Puma in development;

[shopify_app]: #
[puma]: #
[sidekiq]: #
[pg]: #
[dotenv-rails]: #
[rails_12factor]: #

### Authentication, Sessions and the Shop Model
The functionality provided by the ShopifyApp engine includes support for OAuth
authentication and storing session information in a `Shop` model. The
`shopify_app` gem provides a `SessionsController` which is used to log in and
authenticate with Shopify.

As part of the installation of the ShopifyApp gem, a `Shop` model is created,
which stores the domain name and API token for a shop that installs the app.
The DiscoApp gem extends this model with the following:

- A `status` flag indicating the installation status of the app for that Shop;
- A number of attributes with general information about the Shop (email
  address, country, Shopify plan type, et cetera);
- A check to queue an `AppInstalledJob` background task on installation (see
  below for more information on background tasks and DiscoApp).

### Background Tasks
A base `DiscoApp::ShopJob` class inherits from `ActiveJob::Base` and can be
used to queue jobs that need to take place in the API context of a particular
shop. This means that inside the `perform` method of a `ShopJob`, all API calls
will automatically be made on behalf of the shop, like so:

```
class FindAllProductsJob < DiscoApp::ShopJob
  def perform(domain)
    ShopifyAPI::Product.find(:all)
  end
end
```

Note that the first argument of the `perform` method on a `ShopJob` *must
always* be the Shopify domain of the context shop (eg `example.myshopify.com`).

During the setup process, DiscoApp creates some default jobs that are queued
during installation or after specific webhooks are received. They are:

- `AppInstalledJob`, triggered when the application is installed. By default,
  this job uses the Shopify API to set up webhooks and to perform initial data
  synchronisation.
- `AppUninstalledJob`, triggered when the `app/uninstalled` webhook is
  received. By default, this job simply updates the `status` flag on the `Shop`
  model, but you may wish to add tasks like sending a cancellation email or the
  like.
- `ShopUpdateJob`, triggered when the `shop/update` webhook is received. By
  default, this task keeps the metadata attributes on the relevant `Shop`
  model up to date.

### Webhooks
As you may have noticed from the preceding section, webhooks and background
tasks are closely linked. The DiscoApp Engine routes requests to `/webhooks`
to the `process_webhook` method on `DiscoApp::WebhooksController`.

When the controller receives an inbound webhook, it is automatically verified
using the application's secret key. The controller then attempt to queue a job
matching the topic name of the incoming webhook (eg `app/uninstalled` will try
to queue a job named `AppUninstalledJob`). Two arguments will be passed to the
job's `perform` method: the domain of the shop the webhook was related to, and
the JSON payload of the webhook as a hash object.

There shouldn't be any need to extend or override
`DiscoApp::WebhooksController` inside an application - all application logic
should simply be placed inside the relevant `*Job` class.

Webhooks should generally be created inside the `perform` method of the
`AppInstalledJob` background task. By default, webhooks are set up to listen
for the `app/uninstalled` and `shop/update` webhook topics.


## Contributing
While developing Shopify applications using the DiscoApp Engine, you may see
something that could be improved, or perhaps notice a pattern that's becoming
common across a number of applications.

In those cases, please consider taking the time to raise an issue or pull
request against the DiscoApp repository.