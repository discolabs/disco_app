def find_shop(search)
  DiscoApp::Shop.find_by_shopify_domain("#{search}.myshopify.com") || DiscoApp::Shop.find_by_shopify_domain(search) || DiscoApp::Shop.find_by_domain(search)
end
