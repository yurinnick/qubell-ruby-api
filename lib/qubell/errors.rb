# Encoding: utf-8

module Qubell
  # Qubell module exceptions
  module Exceptions
    # Base exception
    class BaseError < StandardError
      attr_reader :error_code

      def initialize(error_code, msg = 'unknown status code')
        super msg
        @error_code = error_code
      end
    end

    # Instance action execution error
    class ExecutionError < BaseError
      def initialize(msg = 'instance is a submodule or active')
        super '400', msg
      end
    end

    # Authentication error
    class AuthenticationError < BaseError
      def initialize(msg = 'invalid credentials')
        super '401', msg
      end
    end

    # Invalid permissions error
    class PermissionsDeniedError < BaseError
      def initialize(msg = 'insufficient privileges')
        super '403', msg
      end
    end

    # Unavaliable resource error
    class ResourceUnavaliable < BaseError
      def initialize(msg = 'resource doesn’t exist')
        super '404', msg
      end
    end

    # Workflow execution error
    class WorkflowError < BaseError
      def initialize(msg = 'another workflow is already running')
        super '409', msg
      end
    end

    # Invalid input error
    class FormatError < ExecutionError
      def initialize(msg = 'incorrect format or data')
        super
      end
    end

    # Instance destoy error
    class DestroyError < ExecutionError
      def initialize(msg = 'specified instance is either a submodule or active')
        super
      end
    end
  end
end
