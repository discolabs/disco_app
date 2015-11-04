/**
 * disco_app/shopify-turbolinks.js
 * Some tweaks to help Turbolinks play nicely with the Embedded App SDK.
 */
jQuery(document).on('page:load', function(e) {
  ShopifyApp.pushState(window.location.pathname);
});
