module Wompi
  class Resource
    def self.get(path, params = {}, auth_type: :private)
      Client.new.call(:get, path, params, auth_type: auth_type)
    end

    def self.post(path, params = {}, auth_type: :private)
      Client.new.call(:post, path, params, auth_type: auth_type)
    end
  end
end