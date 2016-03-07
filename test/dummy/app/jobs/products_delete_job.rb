class ProductsDeleteJob < DiscoApp::ShopJob

  def perform(shopify_domain, product_data)
    Product.synchronise_deletion(@shop, product_data)
  end

end
