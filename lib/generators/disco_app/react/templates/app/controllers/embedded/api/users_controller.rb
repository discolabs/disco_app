module Embedded
  module Api
    class UsersController < BaseController

      def current
        render json: ApiResponse.serialize(@user)
      end

    end
  end
end
