module DiscoApp
  module Flow
    class ProcessTrigger

      include Interactor

      delegate :shop, :trigger, to: :context

      def call
        #
      end

    end
  end
end
