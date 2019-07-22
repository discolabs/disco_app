module DiscoApp
  class UserSerializer

    include FastJsonapi::ObjectSerializer

    attributes :email, :first_name, :id, :last_name

    attribute :initials do |user|
      [user.first_name, user.last_name].compact.map(&:first).join
    end

  end
end
