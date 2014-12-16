# Encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

module Qubell
  describe Configuration do
    describe '#endpoint' do
      it 'default value is https://express.qubell.com' do
        expect(Qubell::Configuration.new.endpoint).to eq('https://express.qubell.com')
      end
      it 'can set value' do
        config = Qubell::Configuration.new
        config.endpoint = 'test'
        expect(config.endpoint).to eq('test')
      end
    end
    describe '#api_version' do
      it 'default value is 1' do
        expect(Qubell::Configuration.new.api_version).to eq('1')
      end
      it 'can set value' do
        config = Qubell::Configuration.new
        config.api_version = '2'
        expect(config.api_version).to eq('2')
      end
    end
    describe '#username' do
      it 'default value is nil' do
        expect(Qubell::Configuration.new.username).to eq(nil)
      end
      it 'can set value' do
        config = Qubell::Configuration.new
        config.username = 'username'
        expect(config.username).to eq('username')
      end
    end
    describe '#password' do
      it 'default value is nil' do
        expect(Qubell::Configuration.new.password).to eq(nil)
      end
      it 'can set value' do
        config = Qubell::Configuration.new
        config.password = 'password'
        expect(config.password).to eq('password')
      end
    end
    describe '#to_s' do
      it 'return json string' do
        config = Qubell::Configuration.new
        config.username = 'username'
        config.password = 'password'
        expect(config.to_s).to eq('{"endpoint": "https://express.qubell.com",' \
                                      '"api_version": "1",' \
                                      '"username": "username",' \
                                      '"password": "password"}')
      end
    end
  end
end
#
# describe QubellAPI do
#   describe 'constractor' do
#     describe 'without required parameters' do
#       it 'requires username' do
#         expect { QubellAPI.new }.to raise_error(KeyError)
#         expect { QubellAPI.new(password: 'password') }.to raise_error(KeyError)
#       end
#
#       it 'requires password' do
#         expect { QubellAPI.new(username: 'test') }.to raise_error(KeyError)
#       end
#     end
#
#     describe 'with required parameters' do
#       let(:resource) { QubellAPI.new(username: 'test', password: 'password') }
#
#       it 'has default endpoint' do
#         expect(resource.endpoint).to eql('https://express.qubell.com')
#       end
#
#       it 'has default api version' do
#         expect(resource.api_version).to eql('1')
#       end
#     end
#
#     describe 'with additional parameters' do
#       let(:resource) do
#         QubellAPI.new(
#         username: 'test',
#         password: 'password',
#         endpoint: 'http://test.qubell.com',
#         api_version: '2')
#       end
#       let(:endpoint) { resource.endpoint }
#       let(:api_version) { resource.api_version }
#
#       it 'uses specified endpoint' do
#         expect(resource.endpoint).to equal(endpoint)
#       end
#
#       it 'uses specified api version' do
#         expect(resource.api_version).to equal(api_version)
#       end
#     end
#   end
#
#   describe 'public methods' do
#     let(:resource) { QubellAPI.new(username: 'test', password: 'password') }
#     let(:endpoint) { resource.endpoint }
#     let(:api_version) { resource.api_version }
#     let(:base_url) { "#{endpoint.sub!(%r{\/\/}, '//user:pass@')}" }
#     let(:app_id) { '50dd88bee4b082b7a96d072e' }
#     let(:org_id) { '50dd88bee4b082b7a96d072e' }
#     let(:env_id) { '50dd88bee4b082b7a96d072e' }
#
#     describe 'get_organizations' do
#       let(:url) do
#         "#{base_url}/api/#{api_version}/organizations"
#       end
#       let(:data) { '[{"id": "50dd88bee4b082b7a96d072e", "name": "TestOrg"}]' }
#
#       subject { resource.organizations }
#
#       it_behaves_like 'common_get_method'
#     end
#
#     describe 'get_applications(org_id)' do
#       let(:url) do
#         "#{base_url}/api/#{api_version}/organizations/#{org_id}/applications"
#       end
#       let(:data) { '[{"id": "50dd88bee4b082b7a96d072e", "name": "TestApp"}]' }
#
#       subject { resource.applications(org_id) }
#
#       context 'with valid organization id' do
#         it_behaves_like 'common_get_method'
#       end
#
#       context 'with invalid organization id' do
#         it_behaves_like 'unexisting resource response'
#       end
#     end
#
#     describe 'get_revisions(app_id)' do
#       let(:url) do
#         "#{base_url}/api/#{api_version}/applications/#{app_id}/revisions"
#       end
#       let(:data) { '[{"id": "50dd88bee4b082b7a96d072e", "name": "TestRev"}]' }
#
#       subject { resource.revisions(app_id) }
#
#       it_behaves_like 'common_get_method'
#
#       context 'with invalid revision id' do
#         it_behaves_like 'unexisting resource response'
#       end
#     end
#
#     describe 'get_instances(env_id)' do
#       let(:url) do
#         "#{base_url}/api/#{api_version}/environments/#{env_id}/instances"
#       end
#       let(:data) { '[{"id": "50dd88bee4b082b7a96d072e", "name": "TestRev"}]' }
#
#       subject { resource.instances(env_id) }
#
#       # if 'sadasd' do
#       #   File.stub(:open).with("manifest","yaml") { StringIO.new(data) }
#       # end
#       context 'with invalid revision id' do
#         it_behaves_like 'unexisting resource response'
#       end
#     end
#   end
# end
