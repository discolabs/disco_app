module DiscoApp
  class Plan < ActiveRecord::Base

    enum status: [:available, :unavailable, :hidden]

  end
end
