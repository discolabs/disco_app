# Upgrading
This file contains more detailed instructions on what's required when updating
an application between one release version of the gem to the next. It's intended
as more in-depth accompaniment to the notes in `CHANGELOG.md` for each version.

## Upgrading from 0.16.0 to Unreleased (inclusive)
Ensure database migrations are brought across and run:

```
bundle exec rake disco_app:install:migrations`
bundle exec rake db:migrate
```

## Upgrading from 0.15.2 to 0.16.0 (inclusive)
Upgrade your app to Rails version 5.2. See the [Rails upgrade docs](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#upgrading-from-rails-5-1-to-rails-5-2).

One big change is the introduction of the [Credentials API](https://github.com/rails/rails/pull/30067), which is intended to replace `config/secrets.yml` and `config/secrets.yml.enc`, and works much like [Ansible Vault](https://docs.ansible.com/ansible/2.6/user_guide/vault.html). There's no need to migrate old secrets usage, since the two behaviours can sit side by side. However, if you do want to try it out, make sure to add the following to your `config/environments/*.rb` file:
```
config.require_master_key = true
```

## Upgrading from 0.14.0 to 0.15.2 (inclusive)
No changes required.

## Upgrading from 0.13.8 to 0.14.0
Update your app's `.ruby-version` to 2.5.0.

Upgrade your app to Rails version 5.1. See [the wiki](https://github.com/discolabs/disco_app/wiki/Upgrade-to-Rails-5.1)
for detailed instructions on this upgrade.

## Upgrading from 0.13.7 to 0.13.8
Update your app's `.ruby-version` to 2.4.1.

Upgrade your app to Rails version 4.2.8.

```
# when using homebrew and rbenv:
brew update
brew upgrade rbenv
rbenv install 2.4.1
```

## Upgrading from 0.13.6 to 0.13.7
### New editor config file
A new default `.editorconfig` configuration file has been added to the list of
default files copied over in an initial `disco_app` install. For any existing
apps, you should copy this file from `disco_app` into the root of your
application directory.

### New partner app generator
A Shopify Partner app generator has been added, which allows you to create a new app
for a given project via a task (refer to the [README](./README.md) for setup).
For running this task on a pre-existing project, you will need to add the `mechanize`
gem into `:development` group in the project's `Gemfile` and `bundle install`

### Change to implementation of `as_liquid` in `CanBeLiquified` concern
The implementation of `as_liquid` has changed (`to_liquid` remainins unchanged).
Please check to see if your app calls `as_liquid` directly and update as required.

## Upgrading from 0.13.5 to 0.13.6
No changes required.

## Upgrading from 0.13.4 to 0.13.5
### New git ignore rule
A rule to ignore `*.pgdump` has been added to the default `.gitignore` template.
You may want to add this to the app's current `.gitignore` now.

### Prepared statements off by default
We've made a change to turn off prepared statements in Postgres by default, as
they can chew up a *lot* of memory without necessarily providing much in the
way of speed increase (see https://github.com/rails/rails/issues/21992).

You should follow suit and add `prepared_statements: false` to the `database.yml`
in your application.

### Run bugfix migration
This release includes a migration that fixes a bug with a unique index on the
`disco_app_users` table. Make sure you copy across the latest version of the
migration and run on your app with:

```
bundle exec rake disco_app:install:migrations`
bundle exec rake db:migrate
```

## Upgrading from 0.13.3 to 0.13.4
The `renderErrors()` method in the React `BaseForm` component was renamed to
`getErrorsElement()`. If you were calling `renderErrors()` directly in your
code (unlikely), you'll have to rename it.

## Upgrading from 0.13.2 to 0.13.3
Add .codeclimate.yml and .rubocop.yml from the root directory of `disco_app`
to the root directory of your app, refer to the Rubocop section in the [README](./README.md#rubocop),
if you wish to change the rubocop configuration

## Upgrading from 0.13.1 to 0.13.2
No changes required.

## Upgrading from 0.12.7 to 0.13.1
### Updated checkbox component
Check that your usage of `InputCheckbox`, if used, matches the updated component.
The previous component didn't work very well so it's unlikely you're using it.

### User authentication
Ensure you copy migrations from  from `disco_app` using
`rake disco_app:install:migrations`, then `rake db:migrate`.

To use the new Shopify user authentication functionality, refer to the
User Authentication section in the [README](./README.md#user-authentication).

## Upgrading from 0.12.6 to 0.12.7
No changes required.

## Upgrading from 0.12.5 to 0.12.6
No changes required.

## Upgrading from 0.12.4 to 0.12.5
### Subscription reporting
Set `DISCO_API_URL` in production if your app should report subscriptions to the
Disco API.

### Rollbar person reporting
Add the following to `initializer/rollbar.rb`:

```
config.person_method = 'current_shop'
config.person_username_method = 'shopify_domain'
```

## Upgrading from 0.12.3 to 0.12.4
No changes required - only a bugfix release.

## Upgrading from 0.12.2 to 0.12.3
No changes required - only a bugfix release.

## Upgrading from 0.12.1 to 0.12.2

### Update shopify_app gem
Remove the version specification for `shopify_app` in your `Gemfile`. Rename any
occurences of `ShopifyApp::Controller` to `ShopifyApp::LoginProtection`.

Remove `redirect_uri` variables in:
- `.env` and `.env.local` files
- `shopify_app` and `omniauth` initializers

## Upgrading from 0.12.0 to 0.12.1

### Updated uglifier gem
Ensure that your `uglifier` gem dependency in your `Gemfile` depends on `~> 3.0`.

## Upgrading from 0.11.1 to 0.12.0

### Changed dependencies
The major difference for this upgrade is the change to the dependencies regime for
the `disco_app` gem. The dependencies specified in the Gemspec are now much looser
and should lead to fewer "inconsistent version" issues. The generator now no longer
specifies gem versions when adding gems to the `Gemfile`. After upgrading, you may
want to remove the specific version numbers from your app's `Gemfile` and run a
`bundle update`.

### Migration consolidation
All migrations from the `disco_app` engine have been consolidated into a single
migration. You can either consolidate the migrations for your own app by copying
your `schema.rb` file into a single migration file, or just delete all migrations
added by the `disco_app` gem and ensure your app's existing migrations make sense.

### New API context helper
The Shopify API context helper `.temp {}` is now aliased as `.with_api_context {}`.
You should replace any usages of `.temp` with the new method name.

## Upgrading from 0.11.0 to 0.11.1
No changes required - only a bugfix release.

## Upgrading from 0.10.5 to 0.11.0

### Updated ruby version
The Ruby dependency for `disco_app` was upgraded to the latest stable release of
Ruby (2.3.3). You should ensure the `.ruby-version` and your `Gemfile` is updated
to specify Ruby 2.3.3.

## Upgrading from 0.10.4 to 0.10.5

### Use locale helper
If you're using a shop's local anywhere, you can now replace your existing code
with the new `DiscoApp::Shop.locale` helper.

## Upgrading from 0.10.3 to 0.10.4
There were some significant changes to the React component library and the
styling of some of our components - you should visually inspect each page of
your app after upgrading to check for breaking changes.

## Upgrading from 0.10.2 to 0.10.3
Bugfix release - no changes required.

## Upgrading from 0.10.1 to 0.10.2

### Sidekiq Web UI now available in production
The Sidekiq Web UI can now be accessed on production stores at `/sidekiq` using
the same authentication credentials as the admin pages.

## Upgrading from 0.10.0 to 0.10.1

### Carrier request controller concern now has additional methods
The `find_shop` and `validate_rate_params` methods have been added to the
carrier request controller concern, so you can now remove them from your own
controller implementations if present.

## Upgrading from 0.9.11 to 0.10.0

### Use time zone helper
If you're calculating a shop's timezone anywhere in your app, you can now
replace your existing code with the new `DiscoApp::Shop.time_zone` helper.

### Specify additional webhooks in configuration
Instead of having to override `DiscoApp::SynchroniseWebhooksJob`, you can now
specify the list of additional webhook topics to register for via configuration
in `config/initializers/disco_app.rb`. You should be able to add:

```
DiscoApp.configure do |config|
  ...

  config.webhook_topics = [:'orders/create', :'orders/paid']

  ...
end
```

and delete `app/jobs/disco_app/synchronise_webhooks_job.rb`.

### Specify carrier service callback URL in configuration
As with the specification of webhook topics, you can now specify the callback
URL for any carrier service inside `config/initializers/disco_app.rb`` rather
than having to override the synchronisation job.

Add something like this to your initializer (note the use of the lambda `->`
syntax for lazy evaluation of URL helpers):

```
DiscoApp.configure do |config|
  ...

  config.carrier_service_callback_url = -> { Rails.application.routes.url_helpers.carrier_service_callback_url }

  ...
end
```

and delete `app/jobs/disco_app/synchronise_carrier_service_job.rb`.

### Rollbar now ignores 429 - Too Many Request errors
Add the following to the end of `config/initializers/rollbar.rb`:

```
...
  # Add custom handlers.
  config.before_process << proc do |options|
    if options[:exception].is_a?(ActiveResource::ClientError) and options[:exception].message.include?('Too Many Requests')
      raise Rollbar::Ignore
    end
  end
end
```

## Upgrading from 0.9.10 to 0.9.11

### Upgrade session store gem
Upgrade `activerecord-session_store` to version 1.0.0 in your Gemfile.

### Explicitly set time zone
Add `config.time_zone = 'UTC'` to your `application.rb`.

## Upgrading from 0.9.9 to 0.9.10

### Rendering models as Liquid variables
If you're outputting a model for use in a Liquid template, you can now include
the `DiscoApp::Concerns::CanBeLiquified` concern in your class.

### Writing resource metafields
If you're setting metafields for resources via the Shopify API, life just got a
whole lot easier with `DiscoApp::Concerns::HasMetafields` and the
`write_metafields` method it introduces.

## Upgrading from 0.9.8 to 0.9.9
No changes required - only additional features.

## Upgrading from 0.9.7 to 0.9.8
No changes required - only additional features.

## Upgrading from 0.9.6 to 0.9.7
No changes required - only additional features.

## Upgrading from 0.9.5 to 0.9.6
No changes required - only additional features.

## Upgrading from 0.9.4 to 0.9.5

### Tweak to assets renderer
You now need to specify a prefix (eg `assets/`) to the `assets:` argument of the
`renders_assets` macro. See the README for more.

## Upgrading from 0.9.3 to 0.9.4

### New asset renderer
You now have access to the asset rendering pattern, for much simplified
management of Shopify assets. See the section "Asset Rendering" in the README
for further details.

### Background jobs can have shop context set with shop instance
Until now, when queueing a background task inheriting from `DiscoApp::ShopJob`,
you had to provide the Shopify domain of the shop as the first argument to
`perform` in order to indicate the shop context the job should execute in. This
argument is still required, but we now support passing a `DiscoApp::Shop`
instance directly as a (now preferred) alternative to using the Shopify domain.

This change is backwards-compatible, so you don't *have* to update you code, but
it does offer a slightly nicer syntax and you avoid additional Shop lookups.

Before:

```
class MyJob < DiscoApp::ShopJob
  def perform(shopify_domain, id)
    ... your code ...
  end
end

@shop = DiscoApp::Shop.first
MyJob.perform_later(@shop.shopify_domain, 123)
MyJob.perform_later(@shop.shopify_domain, 456)
```

After:

```
class MyJob < DiscoApp::ShopJob
  def perform(shop, id)
    ... your code ...
  end
end

@shop = DiscoApp::Shop.first
MyJob.perform_later(@shop, 123)
MyJob.perform_later(@shop, 456)
```

## Upgrading from 0.9.2 to 0.9.3

### New data attribute on Shops
The Shop model now has a `data` attribute, which stores all shop information
from Shopify as a `jsonb` attribute. As a result of this change, the following
attributes have been removed from the Shop model:

```
:email, :country_name, :currency, :money_format, :money_with_currency_format,
:plan_display_name, :latitude, :longitude, :customer_email, :password_enabled,
:phone, :primary_locale, :ships_to_countries, :timezone, :iana_timezone,
:has_storefront
```

You should replace any parts of your application code that uses these attributes
to access them through the `data` attribute instead, eg: `@shop.currency`
becomes `@shop.data['currency']`. For commonly-accessed attributes, you may wish
to simply add an accessor method on your model:

```
def currency
  data['currency']
end
```

There is a new rake task, `shops:sync`, which you should run from your app once
this change is deployed. It will pull in and update all shop information from
the Shopify API.

### Removal of Bootstrap CSS styles

From this version onwards, the Bootstrap CSS styles were removed. Please use
the UI Kit styles instead - these were already introduced in a previous version
of disco_app.


## Upgrading to 0.9.2

As this file didn't exist prior to `0.9.2`, no detailed upgrade notes are
available. Please read through the `CHANGELOG.md` and the commits themselves
when upgrading.
