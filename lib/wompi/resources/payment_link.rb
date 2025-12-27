module Wompi
  class PaymentLink < Resource
    def self.create(params = {})
      secret = params.delete(:integrity_secret) || Wompi.configuration.integrity_secret

      if secret
        params[:signature] = Security::Signature.generate(
          params[:reference],
          params[:amount_in_cents],
          params[:currency],
          secret
        )
      end

      post("payment_links", params, auth_type: :private)
    end
  end
end