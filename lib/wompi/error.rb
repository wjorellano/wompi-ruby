module Wompi
  class Error < StandardError; end
  class ApiError < Error; end

  # Error 404: "La entidad solicitada no existe"
  class NotFoundError < Error; end

  # Error 422: Validaciones de entrada fallidas
  class InvalidRequestError < Error
    attr_reader :messages
    def initialize(messages)
      @messages = messages
      super("Errores de validación: #{messages}")
    end
  end
end