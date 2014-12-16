# Encoding: utf-8
# Qubell API wrapper
# @author Nikolay Yurin <yurinnick@outlook.com>

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'json'
require 'base64'
require 'rest_client'

require 'qubell/base'
require 'qubell/errors'
require 'qubell/application'
require 'qubell/organization'
require 'qubell/configuration'
require 'qubell/revision'

# Main Qubell module
module Qubell
  # Implements wrapper for Qubell API
  class API < Base
    # @param [HashMap<String => String>] key
    def initialize(options = {})
      options.each do |key|
        Qubell.configuration do |c|
          c.send("#{key}=", key)
        end
      end
    end
    # Get list of all organizations that current user belong to.
    # @return [Array<Qubell::Organization>] organizations info
    def organizations
      orgs = []
      Qubell::APICall.get('/organizations').each do |org|
        orgs << Qubell::Organization.new(org)
      end
      orgs
    end

    # Get list of instances launched in given environment.
    # @=irnparam [String] env_id queried environment id
    # @return [Array<Hash{String => String}>] instances info
    # def instances(env_id)
    #   get("/environments/#{env_id}/instances")
    # end
  end
end
