/**
 * disco_app/shopify-turbolinks.js
 * Some tweaks to help Turbolinks play nicely with the Embedded App SDK.
 */
jQuery(document).on('turbolinks:load', function() {
  ShopifyApp.pushState(window.location.pathname);
});
