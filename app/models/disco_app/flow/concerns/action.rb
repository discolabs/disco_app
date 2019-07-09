module DiscoApp
  module Flow
    module Concerns
      module Action

        extend ActiveSupport::Concern

        included do
          belongs_to :shop

          self.table_name = :disco_app_flow_actions

          enum status: {
            pending: 0,
            succeeded: 1,
            failed: 2
          }

          def properties
            read_attribute(:properties).with_indifferent_access
          end
        end

      end
    end
  end
end
