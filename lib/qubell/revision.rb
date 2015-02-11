require 'qubell/base'

module Qubell
  # Qubell revision class
  class Revision < Base
    def instances
      Qubell::APICall.get("/revisions/#{id}/instances").map do |instance|
        Qubell::Instance.new(instance)
      end
    end
  end
end
