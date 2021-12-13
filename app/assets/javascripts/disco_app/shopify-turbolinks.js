/**
 * disco_app/shopify-turbolinks.js
 * Some tweaks to help Turbolinks play nicely with the Embedded App SDK.
 */
jQuery(document).on('turbolinks:load', function() {
  const History = AppBridge.actions.History;
  const history = History.create(app);
  history.dispatch(History.Action.PUSH, window.location.pathname);
});
