module DiscoApp
  class ShopJob < ActiveJob::Base

    queue_as :default

    around_perform do |job, block|
      @shop = Shop.find_by!(shopify_domain: job.arguments.first)
      @shop.temp {
        block.call(job.arguments)
      }
    end

  end
end