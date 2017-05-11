class ProductsDeleteJob < DiscoApp::ShopJob

  def perform(_shop, product_data)
    Product.synchronise_deletion(@shop, product_data)
  end

end
