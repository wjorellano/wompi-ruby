module Wompi
  class Pse < Resource
    def self.financial_institutions
      get("pse/financial_institutions", {}, auth_type: :public)
    end
  end
end