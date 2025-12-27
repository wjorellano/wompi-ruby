require 'date'

module Wompi
  class Transaction < Resource
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

      post("transactions", params, auth_type: :private)
    end

    def self.void(id, params = {})
      post("transactions/#{id}/void", params, auth_type: :private)
    end

    def self.find(id)
      get("transactions/#{id}", {}, auth_type: :private)
    end

    def self.all(params = {})
      now = DateTime.now
      defaults = {
        from_date: (now - 30).strftime('%Y-%m-%dT%H:%M:%S'),
        until_date: now.strftime('%Y-%m-%dT%H:%M:%S'),
        page: 1,
        page_size: 20
      }
      get("transactions", defaults.merge(params), auth_type: :private)
    end

    def self.all_pages(params = {})
      all_records = []
      current_page = 1

      loop do
        response = all(params.merge(page: current_page))
        records = response['data']
        break if records.empty?

        all_records.concat(records)
        current_page += 1
      end

      all_records
    end
  end
end