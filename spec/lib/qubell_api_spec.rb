# Encoding: utf-8

require 'webmock/rspec'
require 'spec_helper'
require 'qubell_api'

describe QubellAPI do
  describe 'constractor' do
    describe 'with required parameters' do
      it 'requires username' do
        expect { QubellAPI.new }.to raise_error(KeyError)
        expect { QubellAPI.new(password: 'password') }.to raise_error(KeyError)
      end

      it 'requires password' do
        expect { QubellAPI.new(username: 'test') }.to raise_error(KeyError)
      end

      it 'has default endpoint' do
        qubell_api = QubellAPI.new(username: 'test', password: 'password')
        qubell_api.endpoint.should == 'https://express.qubell.com'
      end

      it 'has default api version' do
        qubell_api = QubellAPI.new(username: 'test', password: 'password')
        qubell_api.api_version.should == '1'
      end
    end

    describe 'with additional parameters' do
      let(:resource) do QubellAPI.new(
        username: 'test',
        password: 'password',
        endpoint: 'http://test.qubell.com',
        api_version: '2')
      end
      let(:endpoint) { resource.endpoint }
      let(:api_version) { resource.api_version }

      it 'uses specified endpoint' do
        expect(resource.endpoint).to equal(endpoint)
      end

      it 'uses specified api version' do
        expect(resource.api_version).to equal(api_version)
      end
    end
  end

end
