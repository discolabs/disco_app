# Change Log
All notable changes to this project will be documented in this file.

## Unreleased
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
