# Encoding: utf-8

module Qubell
  # Base exception for Qubell module
  class BaseError < StandardError
    attr_reader :error_code

    def initialize(error_code, msg = 'unknown status code')
      super msg
      @error_code = error_code
    end
  end

  # Common Qubell API exception
  class ExecutionError < Qubell::BaseError
    def initialize(msg = 'instance is a submodule or active')
      super '400', msg
    end
  end

  # Authentication exception for Qubell module
  class AuthenticationError < Qubell::BaseError
    def initialize(msg = 'invalid credentials')
      super '401', msg
    end
  end

  # Invalid permissions exception for Qubell module
  class PermissionsDeniedError < Qubell::BaseError
    def initialize(msg = 'insufficient privileges')
      super '403', msg
    end
  end

  # Unavaliable resource exception for Qubell module
  class ResourceUnavaliable < Qubell::BaseError
    def initialize(msg = 'resource doesn’t exist')
      super '404', msg
    end
  end

  # Workflow exception for Qubell module
  class WorkflowError < Qubell::BaseError
    def initialize(msg = 'another workflow is already running')
      super '409', msg
    end
  end

  class FormatError < ExecutionError
    def initialize (msg = 'incorrect format or data')
      super
    end
  end

  class DestroyError < ExecutionError
    def initialize (msg = 'specified instance is either a submodule or active')
      super
    end
  end
end
