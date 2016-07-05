# Encoding: utf-8
# Qubell application class
# @author Nikolay Yurin <yurinnick@outlook.com>

require 'qubell/base'

module Qubell
  # Implement Qubell application interface
  class Instance < Base
    attr_reader :environment
    attr_reader :revision

    def initialize(args)
      super
      @environment = args[:environment]
      @revision = args[:revision]
    end

    # Runs the specified application instance workflow.
    # @param [String] workflow instance workflow name
    # @param [Hash{String => String}] workflow instance workflow name
    # @return [Hashes{String => String}] instance id
    def launch_workflow(workflow, _args)
      Qubell::APICall.get("/instances/#{@id}/#{workflow}")
    end

    # Associates user data with the instance.
    # @param [String] data JSON-encoded user data
    # @return [#void]
    def userdata(data)
      Qubell::APICall.put("/instances/#{@id}/userData", data)
    rescue Qubell::ExecutionError
      raise Qubell::FormatError
    end

    # Destroy an application
    # @param [String] force specifies whether the instance should be deleted
    # @return [#void]
    def destroy(force = false)
      status = force ? '1' : '0'
      begin
        Qubell::APICall.delete("/instances/#{@id}?#{status}")
      rescue Qubell::ExecutionError
        raise Qubell::DestroyError
      end
    end

    def instance_of_app?(app)
      global_info[:applicationId] == app.id
    end

    %w(version parameters status).each do |method_name|
      define_method(method_name.to_sym) do
        global_info[method_name]
      end
    end

    private

    def global_info
      Qubell::APICall.get("/instances/#{@id}")
    end
  end
end
