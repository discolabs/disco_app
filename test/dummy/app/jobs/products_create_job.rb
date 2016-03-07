class ProductsCreateJob < DiscoApp::ShopJob

  def perform(shopify_domain, product_data)
    Product.synchronise(@shop, product_data)
  end

end
