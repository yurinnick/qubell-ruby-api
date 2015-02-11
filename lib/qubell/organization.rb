# Encoding: utf-8
# Qubell API wrapper
# @author Nikolay Yurin <yurinnick@outlook.com>

require 'qubell/base'
require 'qubell/application'
require 'qubell/environment'
require 'qubell/api_call'

module Qubell
  # Implements Qubell organization interface
  class Organization < Base
    def applications
      Qubell::APICall.get("/organizations/#{@id}/applications").map do |app|
        app['organization_id'] = @id
        Qubell::Application.new(app)
      end
    end

    def environments
      Qubell::APICall.get("/organizations/#{@id}/environments").map do |app|
        Qubell::Environment.new(app)
      end
    end
  end
end
