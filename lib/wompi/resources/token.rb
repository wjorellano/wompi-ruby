module Wompi
  class Token < Resource
    def self.create_card(params = {})
      post("tokens/cards", params, auth_type: :public)
    end

    def self.create_nequi(phone_number)
      post("tokens/nequi", { phone_number: phone_number }, auth_type: :public)
    end

    def self.check_nequi_status(token_id)
      get("tokens/nequi/#{token_id}", {}, auth_type: :public)
    end
  end
end