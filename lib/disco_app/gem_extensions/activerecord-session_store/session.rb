module DiscoApp
  module GemExtensions
    module ActiveRecord
      module SessionStore
        module Session
          extend ActiveSupport::Concern

          included do
            before_save :set_shopify_domain!
          end

          private

            def set_shopify_domain!
              return false unless loaded?
              write_attribute(:shopify_domain, data['shopify_domain'])
            end

        end
      end
    end
  end
end
