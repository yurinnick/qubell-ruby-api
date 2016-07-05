# Encoding: utf-8
# Qubell API wrapper
# @author Nikolay Yurin <yurinnick@outlook.com>

require 'qubell_api'

module Qubell
  module Resources
    # Implements Qubell organization interface
    class Organization < Base
      def applications
        Qubell::APICall.get("/organizations/#{@id}/applications").map do |app|
          app['organization_id'] = @id
          Qubell::Resources::Application.new(app)
        end
      end

      def environments
        Qubell::APICall.get("/organizations/#{@id}/environments").map do |app|
          Qubell::Resources::Environment.new(app)
        end
      end
    end
  end
end
