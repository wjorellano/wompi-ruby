require_relative "wompi/version"
require_relative "wompi/configuration"
require_relative "wompi/error"
require_relative "wompi/client"
require_relative "wompi/resource"
require_relative "wompi/security/signature"
require_relative "wompi/resources/token"
require_relative "wompi/resources/transaction"
require_relative "wompi/resources/merchant"
require_relative "wompi/resources/pse"
require_relative "wompi/resources/payment_link"

module Wompi
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end