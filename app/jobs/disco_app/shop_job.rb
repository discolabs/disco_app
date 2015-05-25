# The base class for all jobs that should be performed in the context of a particular Shop's API session. The first
# argument to any job inheriting from this class must be the domain of the relevant store, so that the appropriate
# Shop model can be fetched and the temporary API session created.

module DiscoApp
  class ShopJob < ActiveJob::Base

    queue_as :default

    around_perform do |job, block|
      @shop = ::Shop.find_by!(shopify_domain: job.arguments.first)
      @shop.temp {
        block.call(job.arguments)
      }
    end

  end
end