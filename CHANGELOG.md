# Change Log
All notable changes to this project will be documented in this file.

## 0.18.0 - 2020-04-15
### Changed
- Upgraded to Rails 6
- Upgraded to Ruby 2.6.5
- Upgraded to shopify_api 9
- Upgraded to shopify_app 12
- Upgraded to sidekiq 6
- Replaced .ruby-version with .tool-versions
- Updated Timber initialiser
- Updated README

## 0.17.0 - 2019-07-16
### Added
- Timber logging for generated apps
- rubocop-performance and rubocop-rails plugins
- Support for AppSignal
- Generator for React applications

### Changed
- Switch from Minitest to RSpec as the testing library for generated apps
- Update rubocop.yml file
- Lock shopify_api version to avoid breaking changes
- Upgrade Rails to 5.2.2 to avoid gem vulnerabilities
- Run rubocop auto-corrections
- Use with_indifferent_access when reading Flow properties
- Renaming of methods and general refactoring

## 0.16.1 - 2019-01-01
### Added
- Support for Shopify Flow triggers and actions

## 0.16.0 - 2018-10-01
### Changed
- Update to Rails 5.2
- Add support for staging environment
- Update Rubocop config and make sure generated files comply

## 0.15.2 - 2018-08-05
### Changed
- Final (hopefully) bugfix for dotfolder problem

## 0.15.1 - 2018-08-05
### Changed
- Actual fix for Github dotfolder problem
- Updated release instructions for Gemfury

## 0.15.0 - 2018-08-05
### Changed
- Webhook controller now a concern for extensibility

## 0.14.5 - 2018-08-04
### Added
- VS code support

### Changed
- Init script fix
- Github dotfile fix

## 0.14.4 - 2018-05-18
### Changed
- Bugfix for case-insensitive comparison in `has_tag?` taggable method

## 0.14.3 - 2018-05-02
### Changed
- Loosely set the Rails version to '~> 5.1.0' to allow minor patches

## 0.14.2 - 2018-04-16
### Added
- New initialise.sh script to make starting applications a single command.

### Changed
- Fix for dotfiles not being included on Gemfury
- Explicitly specify Rails '5.1', not '~> 5.1'

## 0.14.1 - 2018-04-14
### Changed
- Bugfix for webhook controller authenticity token issue
- Bugfix for proxy and webhook signature verification issue

## 0.14.0 - 2018-02-28
### Added
- Add README template
- Add Rollbar Rake task

### Changed
- Update to Ruby 2.5.0
- Update to Rails 5.1
- Improve webhooks sync output
- Rubocop updates
- Change source of `disco_app` gem to Gemfury

## 0.13.8 - 2017-08-16
### Added
- Add ability to enforce a whitelist of stores that are allowed to install the app

### Changed
- Update to Ruby 2.4.1

## 0.13.7 - 2017-07-22
### Added
- Add a default `.editorconfig` to help enforce coding conventions
- Added Partner app generator via a new PartnerAppService and rake task
- Tweaked behaviour of `as_liquid` to allow overrides

## 0.13.6 - 2017-06-21
### Added
- Add rake task to synchronize `DiscoApp::User` locally

## 0.13.5 - 2017-06-06
### Added
- Added `*.pgdump` to the default git ignore file
- Added `has_tag?` helper method to `Taggable` concern
- Added Rollbar "Person tracking" for `ShopJob`
- Added overrides to the `data` attribute for `Synchronises` models to allow
  accessing the `data` hash with indifferent access.

### Changed
- Turn prepared statements off by default in config/database.yml template
- Bugfix for indexes on `disco_app_users` table

## 0.13.4 - 2017-05-21
### Changed
- Refactored errors in `BaseForm` component

## 0.13.3 - 2017-05-12
### Changed
- Added codeclimate and rubocop to disco_app generator
- Added custom configuration for rubocop

## 0.13.2 - 2017-04-14
### Changed
- Support automatic login on user-authenticated controllers

## 0.13.1 - 2017-03-29
### Changed
- Fixed bug caused by method in `DiscoApp::User` model

## 0.13.0 - 2017-03-29
### Changed
- Improved the `InputCheckbox` React form component
- Allow Shopify User Authentication
- Added `DiscoApp::UserSessionsController` and `DiscoApp::Concerns::UserAuthenticatedController`
- Added `DiscoApp::User` model
- Add ability to manage `sources` of Shop subscriptions from within the Admin UI

## 0.12.7 - 2017-03-17
### Changed
- Allow synchronising models directly from Shopify API resources

## 0.12.6 - 2017-03-10
### Changed
- Better support for Turbolinks with embedded apps

## 0.12.5 - 2017-03-09
### Added
- Tie errors reported to Rollbar to it concerned Shop
- Auto-login shop if url has valid hmac and shop domain
- Report subscription information to Disco API if ENV var set

## 0.12.4 - 2017-02-08
### Changed
- Fixed bug caused by moved template file in `shopify_app`

## 0.12.3 - 2017-02-08
### Changed
- Fix bug caused by trying to include a class rather than module from `shopify_app`

## 0.12.2 - 2017-01-27
### Removed
- `SHOPIFY_APP_REDIRECT_URI` from `shopify_app` and `omniauth` initializers, `.env` and `.env.local`
as the login redirection is handled from shopify omniauth

### Changed
- Changed `ShopifyApp::Controller` to `ShopifyApp::LoginProtection`
- include `ShopifyApp::LoginProtection` to `DiscoApp::Concerns::AuthenticatedController`

## 0.12.1 - 2017-01-25
### Changed
- Updated `uglifier` gem to `~> 3.0`

## 0.12.0 - 2017-01-25
### Added
- UI component style additions for tables and images with aspect ratios

### Changed
- Major refactor of dependencies; `disco_app` is now much looser in its requirements
- Consolidated all `disco_app` migrations to a single file to avoid common issues
- `shop.temp` now aliased as `shop.with_api_context` for better readability
- Minor tweaks to Rules Editor component

## 0.11.1 - 2017-01-11
### Changed
- Bugfix for `react-rails` gem version

## 0.11.0 - 2017-01-11
### Changed
- Updated the version of `ruby` to 2.3.3
- Improvements to React component library

## 0.10.5 - 2016-11-05
### Added
- New `locale` helper to DiscoApp::Shop model
- Added `sychronise_by` method to synchronises concern

## 0.10.4 - 2016-10-15
### Changed
- Improvements to the React component library and styling

## 0.10.3 - 2016-10-04
### Changed
- Bugfix for Sidekiq Web UI authentication

## 0.10.2 - 2016-10-04
### Added
- Sidekiq Web UI is now accessible in production at `/sidekiq`

## 0.10.1 - 2016-09-17
### Changed
- Added `find_shop` and `validate_rate_params` methods to carrier request
  controller concern

## 0.10.0 - 2016-09-17
### Added
- New `time_zone` helper to DiscoApp::Shop model

### Changed
- Additional webhook topics are now specified in the `disco_app.rb` initializer
  instead of overriddng the webhooks synchronisation job
- Carrier service callback URL is now specified in the `disco_app.rb`
  initializer instead of overriding the carrier service synchronisation job
- Prevent Rollbar from reporting `429 Too Many Request` errors

## 0.9.11 - 2016-09-07
### Added
- Support for "not"-type conditions in Rule Editors
- InputCheckbox React component
- Support for `_html` attributes in DiscoApp::Concerns::CanBeLiquified

### Changed
- Minor improvements to some React components
- Set `config.time_zone = 'UTC'` in `application.rb` on install

## 0.9.10 - 2016-08-13
### Added
- DiscoApp::Concerns::CanBeLiquified
- DiscoApp::Concerns::HasMetafields

## 0.9.9 - 2016-07-26
### Changed
- Added affiliate stores to be considered as development stores

## 0.9.8 - 2016-07-22
### Added
- Provide a better warning to store owners

### Changed
- Development stores no longer charged by default
- Depend on Nokogiri 1.6.8

## 0.9.7 - 2016-06-21
### Added
- `Taggable` concern for models representing synchronised Shopify resources that
  can have tags applied.
- `synchronise_all` class method for models with the `Synchronises` concern.

## 0.9.6 - 2016-06-08
### Added
- Additional React components (`UISection`, `Table`, `CardFooter`)
- Minification support for Javascript assets in the Asset Renderer
- Support for breadcrumbs when initialising the Shopify Bar

## 0.9.5 - 2016-06-01
### Changed
- Require a folder prefix (eg `assets/`) when using to `render_assets`.

## 0.9.4 - 2016-05-31
### Added
- Asset rendering functionality, allowing the use of a `renders_assets` macro to
  easily define a group of assets to be rendered and updated automatically on
  model save.

### Changed
- Background jobs inheriting from `DiscoApp::Shop` can now accept a shop model
  directly as the first argument, as well as a Shopify domain.

## 0.9.3 - 2016-05-23
### Added
- Added a `data` attribute to the `Shop` model, to synchronise all Shop data from
  Shopify in a `jsonb` field
- Explicit dependency on `nokogiri` gem version 1.6.7.2.
- New rake task: `shops:sync`, for updating shop data information.

### Removed
- A large number of attributes on the `Shop` model were removed, as they are now
  accessible from within the `data` attribute
- Removed bootstrap-sass

### Changed
- The `mailify` and `monitorify` optional generators are not available. Instead, they
  are available as part of the main `disco_app` generator.
- Updated the version of `ruby` to 2.3.1.
- Updated the version of `newrelic_rpm` to 3.15.2.317.


## 0.9.2 - 2016-05-13
### Added
- Support for filtering shops with a query in the admin

## 0.9.1 - 2016-05-13
### Changed
- Minor bugfix for admin

## 0.9.0 - 2016-05-12
### Added
- Basic Form React components
- React Rule Editor component
- Support for Postgresql only
- Use Shopify's UI-Kit for styling: https://help.shopify.com/api/sdks/sales-channel-sdk/ui-kit
- Postgres Sequence ID update task.

### Changed
- `react-rails` is now a core part of `disco_app`

### Removed
- Removed the adminify generator, admin is installed by default
- Removed Bootstrap support

## 0.8.9 - 2016-04-25
### Added
- Source tracking, cookie-based plan code application.

### Changed
- Minor style and function improvements to admin.

## 0.8.8 - 2016-04-01
### Added
- New subscriptions and charges framework.

### Changed
- Update `react-rails` gem to 1.6.0

## 0.8.7 - 2016-03-10
- Fixed bug when deleting webhook resource instances

## 0.8.6 - 2016-03-07
### Added
- Add application administration panel, mounted at `/admin` and protected with
  HTTP Basic Auth

### Changed
- Moved all controller concerns inside the `DiscoApp::Concerns` namespace for
  consistency with the way model concerns are patterned.
- Update `rails` gem to v4.2.5.2 for security patches.
- Rename `SynchroniseWithShopify` concern to simply `Synchronises`, and add a
  couple of helper methods for deciding whether to synchronise models.

## 0.8.5 - 2016-02-22
### Changed
- Fix `omniauth-shopify-oauth2` to `1.1.11`

## 0.8.4 - 2016-02-22
### Added
- `DiscoApp::Configuration` model, to be set up with `disco_app.rb` initializer
- Automatically set `@shop` instance variable on Proxy Controller concern
- Initial implementation of `SynchronisesWithShopify` model concern

### Changed
- All `id` fields default to `bigint` thanks to `rails-bigint-pk` gem
- Move `Rails.configuration.x.shopify_app_name` to `DiscoApp.configuration`
- Move `Rails.configuration.x.shopify_app_proxy_prefix` to
  `DiscoApp.configuration.app_proxy_prefix`
- Update to latest versions of monitoring gems

## 0.8.3 - 2016-02-04
### Changed
- `DiscoApp::Shop.protocol` now always returns `https`

## 0.8.2 - 2016-01-28
### Changed
- `rollbarify` generator renamed to `monitorify`
- Added New Relic support in new `monitorify` generator
- Ensure webhook addresses are current when synchronising webhooks
- Improved carrier service syncing

## 0.8.1 - 2016-01-26
### Changed
- Fix for ShopifyApp generator not being run
- Update `rails` gem to v4.2.5.1 for security patches
- Update `react-rails` gem to 1.5.0

## 0.8.0 - 2016-01-20
### Changed
- Use Ruby 2.3.0

## 0.7.2 - 2016-01-19
### Changed
- Update `rails` gem to v4.2.5
- Update `sidekiq` gem to v4.0.2

### Added
- Use threadsafe version of Active Record

## 0.7.1 - 2016-01-13
### Changed
- Minor bugfix

## 0.7.0 - 2016-01-13
### Changed
- Move session storage to Active Record with `DiscoApp::Session`
- Update `shopify_app` gem to v6.4.1
- Update Rollbar and OJ gems for optional generator

## 0.6.9 - 2015-11-30
### Added
- Add `disco_app:rollbarify` optional generator

## 0.6.8 - 2015-11-19
### Added
- Add `link_to_modal` helper
- Add modal layout

## 0.6.7 - 2015-11-18
### Changed
- Change to registering a single carrier service

## 0.6.6 - 2015-11-18
### Added
- Added carrier service synchronisation with same pattern as for webhooks
- Added `carrier_services:sync` rake task

## 0.6.5 - 2015-11-16
### Added
- `SHOPIFY_APP_PROXY_PREFIX` configuration and environment variable

## 0.6.4 - 2015-11-11
### Added
- Disco App test helper, which injects into an app's `test/test_helper.rb`

### Changed
- Webhook controller now passes data as an indifferent hash by default
- Rake tasks now stored inside Disco App engine rather than created in app
- Moved webhook synchronisation to its own independent job
- Added `webhooks:sync` rake task

## 0.6.3 - 2015-11-05
### Added
- React component library
- More admin styles for tables and grids

### Changed
- Upgraded to React v0.14

## 0.6.2 - 2015-11-04
### Added
- Start of the Dev Frame for aiding local development
- `link_to_shopify_admin` view helper
- Better support for Turbolinks and URL state changes

### Changed
- Card content is no longer wrapped in card sections by default

## 0.6.1 - 2015-10-20
### Changed
- Made app installed and shop update jobs extensible with Concerns pattern

## 0.6.0 - 2015-10-19
### Changed
- Moved `Shop` model inside engine
- Made models and jobs extensible via Concerns pattern
- Moved layouts and views inside engine where possible
- Revamped styling to be in line with Shopify Embedded Apps

## 0.5.6 - 2015-10-16
### Added
- This new-format CHANGELOG, based on http://keepachangelog.com
- Ensure Sidekiq processes mailers queue
