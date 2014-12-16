module Qubell
  # Implement Qubell application interface
  class Instance < Base
    # Get the application instance status.
    # @return [Hashes{String => String,Hash}] instances status info
    def status
      get("/instances/#{@id}")
    end

    # Runs the specified application instance workflow.
    # @param [String] workflow instance workflow name
    # @return [Hashes{String => String}] instance id
    def launch_workflow(workflow)
      get("/instances/#{@id}/#{workflow}")
    end

    # Associates user data with the instance.
    # @param [String] userdata JSON-encoded user data
    # @return [#void]
    def upload_user_data(userdata)
      put("/instances/#{@id}/userData", userdata)
    end

    # Destroy an application
    # @param [String] force specifies whether the instance should be deleted
    # @return [#void]
    def destroy(force = false)
      status = force ? '1' : '0'
      delete("/instances/#{@id}?#{status}")
    end
  end
end
