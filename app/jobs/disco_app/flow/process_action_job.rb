module DiscoApp
  module Flow
    class ProcessActionJob < DiscoApp::ShopJob

      def perform(_shop, action)
        ProcessAction.call(action: action)
      end

    end
  end
end
