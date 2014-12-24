require 'yaml'
require 'qubell/errors'

module Qubell
  # Implements Qubell API http call helpers
  class APICall
    %w(get post put delete).each do |http_method|
      define_singleton_method(http_method.to_sym) do |path, *args|
        Qubell.configure do |config|
          RestClient::Resource.new(
              "#{config.endpoint}/api/#{config.api_version}#{path}",
              config.username,
              config.password)
            .send(http_method.to_sym, *args) do |response|
            handle_response(response)
          end
        end
      end
    end

    # @param [String] resp
    def self.handle_response(data)
      if data.code == 200
        case data.headers[:content_type]
        when 'application/json' then JSON.parse(data, symbolize_names: true)
        when 'application/x-yaml' then YAML.load data
        else data.empty? ? nil : data
        end
      else
        handle_error(data)
      end
    end

    # @param [String] response
    def self.handle_error(response)
      case response.code
      when 400 then fail DestroyError, 'instance is a submodule or active'
      when 401 then fail AuthenticationError, 'invalid credentials'
      when 403 then fail PermissionsError, 'insufficient privileges'
      when 404 then fail ArgumentError, 'resource doesn’t exist'
      when 409 then fail ArgumentError, 'another workflow is already running'
      else fail QubellError, "unknown status code #{response.code}"
      end
    end
  end
end
