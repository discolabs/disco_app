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

  # Generate a link that will open its href in an embedded Shopify modal.
  def link_to_modal(name, path, options = {})
    modal_options = {
      src: path,
      title: options.delete(:modal_title),
      width: options.delete(:modal_width),
      height: options.delete(:modal_height),
      buttons: options.delete(:modal_buttons),
    }
    options[:onclick] = "ShopifyApp.Modal.open(#{modal_options.to_json}); return false;"
    options[:onclick].gsub!(/"function(.*?)"/, 'function\1')
    link_to(name, path, options)
  end

  # Render a React component with inner HTML content.
  # Thanks to https://github.com/reactjs/react-rails/pull/166#issuecomment-86178980
  def react_component_with_content(name, args = {}, options = {}, &block)
    args[:__html] = capture(&block) if block.present?
    react_component(name, args, options)
  end

end
