module Embedded
  module Api
    class BaseController < ApplicationController

      include DiscoApp::Concerns::AuthenticatedController
      include DiscoApp::Concerns::UserAuthenticatedController

      rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity

      private

        def unprocessable_entity(exception)
          render json: ApiResponse.serialize(exception.record.errors), status: :unprocessable_entity
        end

    end
  end
end
