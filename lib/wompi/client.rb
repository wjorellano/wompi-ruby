require 'faraday'
require 'json'

module Wompi
  class Client
    def initialize(config = Wompi.configuration)
      @config = config
    end

    def connection
      Faraday.new(url: @config.base_url) do |f|
        f.request :json
        f.response :json
        f.adapter Faraday.default_adapter
      end
    end

    def call(method, path, params = {}, auth_type: :private)
      key = auth_type == :private ? @config.private_key : @config.public_key
      response = connection.send(method, path, params) do |req|
        req.headers['Authorization'] = "Bearer #{key}"
      end
      handle_response(response)
    end

    private

    def handle_response(response)
      case response.status
      when 200, 201 then response.body
      when 404 then raise NotFoundError, response.body.dig('error', 'reason')
      when 422 then raise InvalidRequestError, response.body.dig('error', 'messages')
      else raise ApiError, "Error: #{response.status}"
      end
    end
  end
end