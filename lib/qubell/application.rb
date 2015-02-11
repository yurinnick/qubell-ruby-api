# Encoding: utf-8
# Qubell application class
# @author Nikolay Yurin <yurinnick@outlook.com>

require 'qubell/base'
require 'qubell/revision'
require 'qubell/api_call'
require 'qubell/instance'
require 'qubell/organization'

# Main Qubell module
module Qubell
  # Qubell application class
  class Application < Base
    def initialize(args)
      super
      @organization = args[:organization]
    end
    # Get list of all revisions for given application.
    # @return [Array<Qubell::Revision>] revisions info
    def revisions
      Qubell::APICall.get("/applications/#{@id}/revisions").map do |rev|
        Qubell::Revision.new(rev)
      end
    end

    # Get list of all instances for given application.
    # @return [Array<Qubell::Instance>] revisions info
    def instances
      # Qubell public API is too enterprise for just getting list of instances
      # by application ID. Actually there is no method for this yet.
      # So, store ID of organization in Application class and to get a list of
      # instances we init new organization class, get all environments in this
      # organization, get all instances in this environment and finally
      # filter them by application.
      # Like in one russian fairytail: "his death is at the end of the needle,
      # that needle is in the egg, then egg is in a duck, that duck is in a hare,
      # the hare is in the trunk, and the trunk stands on a high oak"
      Qubell::Organization.new(:id => @organization).environments
      .map { |env| env.instances }.flatten.select do |instance|
        instance.instance_of_app?(self)
      end
    end

    # Get the application instance status.
    # @param [String] content new manifest content
    # @return [String] instances status info
    def update(content)
      Qubell::APICall.put("/applications/#{@id}/manifest",
                          content,
                          content_type: 'application/x-yaml')[:version]
    end

    # Launch new instance of given application.
    # @param [Hash<String => String>] args map of configuration parameters
    # @return [Qubell::Instance] revisions info
    def launch(args)
      id = Qubell::APICall.put("/applications/#{@id}/launch",
                               args.to_json,
                               content_type: 'application/json')['id']
      self.instances.select { |i| i.id == id }
    end

    private

    attr_reader :organization
  end
end
