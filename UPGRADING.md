# Upgrading
This file contains more detailed instructions on what's required when updating
an application between one release version of the gem to the next. It's intended
as more in-depth accompaniment to the notes in `CHANGELOG.md` for each version.

## Upgrading from 0.9.2 to (Unreleased)

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
becomes `@shop.data['currency']`.

There is a new rake task, `shops:sync`, which you should run from your app once
this change is deployed. It will pull in and update all shop information from
the Shopify API.


## Upgrading to 0.9.2

As this file didn't exist prior to `0.9.2`, no detailed upgrade notes are
available. Please read through the `CHANGELOG.md` and the commits themselves
when upgrading.