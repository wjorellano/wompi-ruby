module Wompi
  class Configuration
    attr_accessor :public_key, :private_key, :integrity_secret, :environment

    def initialize
      @environment = :sandbox
    end

    def base_url
      @environment == :production ? "https://production.wompi.co/v1" : "https://sandbox.wompi.co/v1"
    end
  end
end