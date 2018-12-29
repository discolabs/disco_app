require 'interactor'

module DiscoApp
  module Flow
    class ProcessAction

      include Interactor

      delegate :action, to: :context

      def call
        validate_action
      end

      private

        def validate_action
          context.fail! unless action.pending?
        end

    end
  end
end
