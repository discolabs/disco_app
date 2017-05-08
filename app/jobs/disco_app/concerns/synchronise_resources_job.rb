module DiscoApp::Concerns::SynchroniseResourcesJob
  extend ActiveSupport::Concern

  def perform(_shop, class_name, params)
    klass = class_name.constantize

    klass::SHOPIFY_API_CLASS.find(:all, params: params).map do |shopify_resource|
      klass.synchronise(@shop, shopify_resource.serializable_hash)
    end
  end

end
