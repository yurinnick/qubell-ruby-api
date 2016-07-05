require 'qubell_api'

module Qubell
  module Resources
    # Qubell revision class
    class Revision < Base
      def instances
        Qubell::APICall.get("/revisions/#{id}/instances").map do |instance|
          Qubell::Resources::Instance.new(instance)
        end
      end
    end
  end
end
