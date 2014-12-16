require 'api_call'
require 'errors'

module Qubell
  class APICall
    %w(get post put delete).each do |http_method|
      define_singleton_method(http_method.to_sym) do |path, *args|
        RestClient::Resource.new("#{Qubell.configuration.endpoint}/api/" \
                                     "#{Qubell.configuration.api_version}#{path}",
                                 Qubell.configuration.username,
                                 Qubell.configuration.password)
        .send(http_method.to_sym, *args) do |response|
          handle_response(response)
        end
      end
    end

    # @param [String] response
    def self.handle_response(response)
      if response.code == 200
        JSON.load(response)
      else
        handle_error(response)
      end
    end

    # @param [String] response
    def self.handle_error(response)
      case response.code
        when 400 then fail DestroyError, 'instance is either a submodule or active'
        when 401 then fail AuthenticationError, 'invalid credentials'
        when 403 then fail PermissionsError, 'insufficient privileges'
        when 404 then fail ArgumentError, 'resource doesn’t exist'
        when 409 then fail ArgumentError, 'another workflow is already running'
        else fail QubellError, "(#{response.code}) unknown status code\n#{response.body}"
      end
    end
  end
end