require 'yaml'
require 'qubell/errors'

module Qubell
  # Implements Qubell API HTTP call helpers
  class APICall
    %w(get post put delete).each do |http_method|
      define_singleton_method(http_method.to_sym) do |path, *args|
        Qubell.configure do |config|
          RestClient::Resource.new(
            "#{config.endpoint}#{path}",
            config.username,
            config.password
          ).send(http_method.to_sym, *args) do |response|
            handle_response(response)
          end
        end
      end
    end

    # @param [String] response
    def self.handle_response(response)
      if response.code == 200
        case response.headers[:content_type]
        when 'application/json' then JSON.parse(response, symbolize_names: true)
        when 'application/x-yaml' then YAML.load response
        else response.empty? ? nil : response
        end
      else
        handle_error(response.code)
      end
    end

    # @param [String] code
    def self.handle_error(code)
      case code
      when 400 then raise Qubell::Exceptions::ExecutionError
      when 401 then raise Qubell::Exceptions::AuthenticationError
      when 403 then raise Qubell::Exceptions::PermissionsDeniedError
      when 404 then raise Qubell::Exceptions::ResourceUnavaliable
      when 409 then raise Qubell::Exceptions::WorkflowError
      else raise Qubell::Exceptions::BaseError, code
      end
    end
  end
end
