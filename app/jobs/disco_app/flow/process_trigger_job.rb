module DiscoApp
  module Flow
    class ProcessTriggerJob < DiscoApp::ShopJob

      def perform(shop, trigger)
        ProcessTrigger.call(shop: shop, trigger: trigger)
      end

    end
  end
end
