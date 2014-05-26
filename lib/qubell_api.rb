# Encoding: utf-8
# Qubell API wrapper

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'json'
require 'base64'
require 'rest_client'

require 'errors/qubell_error'
require 'errors/authentication_error'
require 'errors/permissions_error'
require 'errors/destroy_error'

class QubellAPI
  attr_accessor :endpoint, :api_version

  def initialize(params = {})
    @endpoint = params.fetch(:endpoint, 'https://express.qubell.com')
    @api_version = params.fetch(:api_version, '1')
    @username = params.fetch(:username)
    @password = params.fetch(:password)
  end

  # Organization methods
  def organizations
    qubell_request('/organizations')
    .get do |response|
      return handle_api_responce(response)
    end
  end

  # Application methods
  def get_applications(org_id)
    qubell_request("/organizations/#{org_id}/applications")
    .get do |response|
      return handle_api_responce(response, org_id)
    end
  end

  def get_revisions(app_id)
    qubell_request("/applications/#{app_id}/revisions")
    .get do |response|
      return handle_api_responce(response, app_id)
    end
  end

  def update_application_manifest(app_id, manifest_path)
    qubell_request("/applications/#{app_id}/manifest")
    .put(File.read(manifest_path), content_type: 'application/x-yaml'
      ) do |response|
      return handle_api_responce(response, app_id)
    end
  end

  # Instance methods
  def get_instances(env_id)
    qubell_request("/environments/#{env_id}/instances")
    .get do |response|
      return handle_api_responce(response, env_id)
    end
  end

  def get_instance_status(instance_id)
    qubell_request("/revisions/#{rev_id}/instances")
    .get do |response|
      return handle_api_responce(response, instance_id)
    end
  end

  def launch_workflow(instance_id, workflow)
    qubell_request("/instances/#{instance_id}/#{workflow}")
    .get do |response|
      return handle_api_responce(response, instance_id)
    end
  end

  def upload_user_data(instance_id, userdata)
    qubell_request("/instances/#{instance_id}/userData")
    .put(userdata) do |response|
      return handle_api_responce(response, instance_id)
    end
  end

  def destroy_instance(instance_id, force)
    force ||= false
    qubell_request("/instances/#{instance_id}?#{force}")
    .delete do |response|
      return handle_api_responce(response, instance_id)
    end
  end

  private

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
