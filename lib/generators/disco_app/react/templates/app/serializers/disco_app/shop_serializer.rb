module DiscoApp
  class ShopSerializer

    include FastJsonapi::ObjectSerializer

    attributes :id, :name, :shopify_url

    attribute :time_zone do |shop|
      shop.time_zone.tzinfo.name
    end

  end
end
