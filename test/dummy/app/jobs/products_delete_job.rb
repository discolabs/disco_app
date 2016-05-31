class ProductsDeleteJob < DiscoApp::ShopJob

  def perform(shop, product_data)
    Product.synchronise_deletion(@shop, product_data)
  end

end
