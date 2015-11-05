module DiscoApp::ApplicationHelper

  # Generates a link pointing to an object (such as an order or customer) inside
  # the given shop's Shopify admin. This helper makes it easy to  create links
  # to objects within the admin that support both right-clicking and opening in
  # a new tab as well as capturing a left click and redirecting to the relevant
  # object using `ShopifyApp.redirect()`.
  def link_to_shopify_admin(shop, name, admin_path, options = {})
    options[:onclick] = "ShopifyApp.redirect('#{admin_path}'); return false;"
    options[:'data-no-turbolink'] = true
    link_to(name, "https://#{shop.shopify_domain}/admin/#{admin_path}", options)
  end

end
