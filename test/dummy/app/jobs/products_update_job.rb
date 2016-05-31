class ProductsUpdateJob < DiscoApp::ShopJob

  def perform(shop, product_data)
    Product.synchronise(@shop, product_data)
  end

end
