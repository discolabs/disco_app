module DiscoApp::ApplicationHelper

  def link_to_shopify_admin(shop, name, admin_path, options = {})
    options[:onclick] = "ShopifyApp.redirect('#{admin_path}'); return false;"
    link_to(name, "https://#{shop.shopify_domain}/admin/#{admin_path}", options)
  end

end
