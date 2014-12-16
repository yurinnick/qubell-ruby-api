# Encoding: utf-8
# Qubell API wrapper
# @author Nikolay Yurin <yurinnick@outlook.com>

require 'qubell/base'
require 'qubell/application'
require 'qubell/api_call'

module Qubell
  class Organization < Base
    def applications
      apps = []
      Qubell::APICall.get("/organizations/#{@id}/applications").each do |app|
        apps << Application.new(app)
      end
      apps
    end
  end
end
