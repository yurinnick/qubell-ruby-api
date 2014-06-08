# Encoding: utf-8
# Qubell API wrapper
# @author Nikolay Yurin <yurinnick@outlook.com>

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'json'
require 'base64'
require 'rest_client'

require 'errors/qubell_error'
require 'errors/authentication_error'
require 'errors/permissions_error'
require 'errors/destroy_error'

# Implements wrapper for Qubell API
class QubellAPI
  # Qubell API endpoint
  attr_accessor :endpoint
  # Qubell API version
  attr_accessor :api_version

  # @param [Hash] params the parameters to configure an API calls with.
  # @option params [String] :endpoint ('https://express.qubell.com')API endpoint
  # @option params [String] :api_version ('1') API version
  # @option params [String] :username
  # @option params [String] :password
  # @return [#self]
  def initialize(params = {})
    @endpoint = params.fetch(:endpoint, 'https://express.qubell.com')
    @api_version = params.fetch(:api_version, '1')
    @username = params.fetch(:username)
    @password = params.fetch(:password)
  end

  # Get list of all organizations that current user belong to.
  # @return [Array<Hash{String => String}>] organizations info
  def organizations
    qubell_request('/organizations')
    .get do |response|
      return handle_api_responce(response)
    end
  end

  # Get list of all applications in given organization.
  # @param [String] org_id queried organization id
  # @return [Array<Hash{String => String}>] applications info
  def get_applications(org_id)
    qubell_request("/organizations/#{org_id}/applications")
    .get do |response|
      return handle_api_responce(response, org_id)
    end
  end

  # Get list of all named revisions for given application.
  # @param [String] app_id queried application id
  # @return [Array<Hash{String => String}>] revisions info
  def get_revisions(app_id)
    qubell_request("/applications/#{app_id}/revisions")
    .get do |response|
      return handle_api_responce(response, app_id)
    end
  end

  # Get the application instance status.
  # @param [String] app_id queried instance id
  # @return [Hashes{String => String}] instances status info
  def update_application_manifest(app_id, manifest_path)
    qubell_request("/applications/#{app_id}/manifest")
    .put(File.read(manifest_path), content_type: 'application/x-yaml'
      ) do |response|
      return handle_api_responce(response, app_id)
    end
  end

  # Get list of instances launched in given environment.
  # @param [String] env_id queried environment id
  # @return [Array<Hash{String => String}>] instances info
  def get_instances(env_id)
    qubell_request("/environments/#{env_id}/instances")
    .get do |response|
      return handle_api_responce(response, env_id)
    end
  end

  # Get the application instance status.
  # @param [String] instance_id queried instance id
  # @return [Hashes{String => String,Hash}] instances status info
  def get_instance_status(instance_id)
    qubell_request("/revisions/#{rev_id}/instances")
    .get do |response|
      return handle_api_responce(response, instance_id)
    end
  end

  # Runs the specified application instance workflow.
  # @param [String] instance_id queried instance_id
  # @param [String] workflow instance workflow name
  # @return [Hashes{String => String}] instance id
  def launch_workflow(instance_id, workflow)
    qubell_request("/instances/#{instance_id}/#{workflow}")
    .get do |response|
      return handle_api_responce(response, instance_id)
    end
  end

  # Associates user data with the instance.
  # @param [String] instance_id instance to associate with
  # @param [String] userdata JSON-encoded user data
  # @return [#void]
  def upload_user_data(instance_id, userdata)
    qubell_request("/instances/#{instance_id}/userData")
    .put(userdata) do |response|
      return handle_api_responce(response, instance_id)
    end
  end

  # Destroy an application
  # @param [String] instance_id instance to destroy
  # @param [String] force specifies whether the instance should be deleted
  # @return [#void]
  def destroy_instance(instance_id, force)
    force ||= false
    qubell_request("/instances/#{instance_id}?#{force}")
    .delete do |response|
      return handle_api_responce(response, instance_id)
    end
  end

  private

  # Create http request with basic auth
  # @param [String] path API resource path
  # @return [RestClient::Resource]
  def qubell_request(path)
    RestClient::Resource
    .new("#{@endpoint}/api/#{@api_version}#{path}", @username, @password)
  end

  def handle_api_responce(response)
    case response.code
    when 200 then JSON.load response
    when 400 then fail DestroyError, 'instance is either a submodule or active'
    when 401 then fail AuthenticationError, 'invalid credentials'
    when 403 then fail PermissionsError, 'insufficient privileges'
    when 404 then fail ArgumentError, 'resource doesn’t exist'
    when 409 then fail ArgumentError, 'another workflow is already running'
    else fail QubellError, '(#{response.code}) unknown status code'
    end
  end
end
