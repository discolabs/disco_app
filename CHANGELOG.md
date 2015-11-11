# Change Log
All notable changes to this project will be documented in this file.

## Unreleased
### Added
- Disco App test helper, which injects into an app's `test/test_helper.rb`

### Changed
- Webhook controller now passes data as an indifferent hash by default

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
