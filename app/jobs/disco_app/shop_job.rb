# The base class for all jobs that should be performed in the context of a particular Shop's API session. The first
# argument to any job inheriting from this class must be the domain of the relevant store, so that the appropriate
# Shop model can be fetched and the temporary API session created.

module DiscoApp
  class ShopJob < ActiveJob::Base

    queue_as :default

    before_perform { |job| find_shop(job) }
    before_enqueue { |job| find_shop(job) }

    around_enqueue { |job, block| shop_context(job, block) }
    around_perform { |job, block| shop_context(job, block) }

    private

      def find_shop(job)
        @shop ||= Shop.find_by!(shopify_domain: job.arguments.first)
      end

      def shop_context(job, block)
        @shop.temp {
          block.call(job.arguments)
        }
      end

  end
end
