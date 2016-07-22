# Upgrading
This file contains more detailed instructions on what's required when updating
an application between one release version of the gem to the next. It's intended
as more in-depth accompaniment to the notes in `CHANGELOG.md` for each version.

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
