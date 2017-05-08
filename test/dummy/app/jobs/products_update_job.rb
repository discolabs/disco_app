class ProductsUpdateJob < DiscoApp::ShopJob

  def perform(_shop, product_data)
    Product.synchronise(@shop, product_data)
  end

end
