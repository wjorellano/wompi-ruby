module Wompi
  class Merchant < Resource
    def self.info
      get("merchants/#{Wompi.configuration.public_key}", {}, auth_type: :public)
    end
  end
end