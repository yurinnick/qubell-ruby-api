# Encoding: utf-8
# Qubell API wrapper
# @author Nikolay Yurin <yurinnick@outlook.com>

require 'qubell/base'
require 'qubell/application'
require 'qubell/api_call'

module Qubell
  # Implements Qubell organization interface
  class Organization < Base
    def applications
      Qubell::APICall.get("/organizations/#{@id}/applications").map do |app|
        Qubell::Application.new(app)
      end
    end
  end
end
