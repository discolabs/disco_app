module Embedded
  module Api
    class ShopsController < BaseController

      def show
        render json: ApiResponse.serialize(@shop)
      end

    end
  end
end
