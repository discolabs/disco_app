module DiscoApp
  module Flow
    class ProcessTriggerJob < DiscoApp::ShopJob

      def perform(_shop, trigger)
        ProcessTrigger.call(trigger: trigger)
      end

    end
  end
end
