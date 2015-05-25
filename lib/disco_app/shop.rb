module DiscoApp
  module Shop

    extend ActiveSupport::Concern
    include ShopifyApp::Shop

    # Alias 'with_shopify_session' as 'temp', as per our existing conventions.
    alias_method :temp, :with_shopify_session

  end
end
