require 'digest'

module Wompi
  module Security
    class Signature
      def self.generate(reference, amount_in_cents, currency, secret)
        raw_string = "#{reference}#{amount_in_cents}#{currency}#{secret}"
        Digest::SHA256.hexdigest(raw_string)
      end
    end
  end
end