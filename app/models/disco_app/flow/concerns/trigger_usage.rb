module DiscoApp
  module Flow
    module Concerns
      module TriggerUsage

        extend ActiveSupport::Concern

        included do
          belongs_to :shop

          self.table_name = :disco_app_flow_trigger_usages
        end

      end
    end
  end
end
