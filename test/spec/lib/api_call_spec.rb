# Encoding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

shared_examples 'a qubell api call' do |method|
  let(:url) { "#{config.endpoint}/api/#{config.api_version}/test" }
  let(:response) { { key1: { key2: %w(value1 value2) } } }
  let(:config) { FactoryGirl.build :configuration }
  let(:class_method) { Qubell::APICall.method(method) }
  let(:data)  { (method == :put || method == :post) ? 'test_data' : {} }

  context 'with json responce body' do
    before do
      stub_request(method, url).to_return(
          status: 200,
          body: response.to_json,
          headers: { :'Content-type' => 'application/json' })
    end
    it 'return collection' do
      expect(class_method.call('/test', data)).to eq(response)
    end
  end

  context 'with yaml responce body' do
    before do
      stub_request(method, url).to_return(
          status: 200,
          body: response.to_yaml,
          headers: { :'Content-type' => 'application/x-yaml' })
    end
    it 'return collection' do
      expect(class_method.call('/test', data)).to eq(response)
    end
  end

  context 'with 400 responce code' do
    before do
      stub_request(method, url).to_return(status: 400)
    end
    it 'raise Qubell::DestroyError ' do
      expect { class_method.call('/test', data) }
      .to raise_error Qubell::DestroyError
    end
  end

  context 'with 401 responce code' do
    before do
      stub_request(method, url).to_return(status: 401)
    end
    it 'raise Qubell::AuthenticationError ' do
      expect { class_method.call('/test', data) }
      .to raise_error Qubell::AuthenticationError
    end
  end

  context 'with 403 responce code' do
    before do
      stub_request(method, url).to_return(status: 403)
    end
    it 'raise Qubell::PermissionsDeniedError ' do
      expect { class_method.call('/test', data) }
      .to raise_error Qubell::PermissionsDeniedError
    end
  end

  context 'with 404 responce code' do
    before do
      stub_request(method, url).to_return(status: 404)
    end
    it 'raise Qubell::ResourceUnavaliable ' do
      expect{ class_method.call('/test', data) }
      .to raise_error Qubell::ResourceUnavaliable
    end
  end

  context 'with 409 responce code' do
    before do
      stub_request(method, url).to_return(status: 409)
    end
    it 'raise Qubell::WorkflowError ' do
      expect{ class_method.call('/test', data) }
      .to raise_error Qubell::WorkflowError
    end
  end
end

module Qubell
  describe Base do
    describe '#get' do
      it_behaves_like 'a qubell api call', :get
    end

    describe '#post' do
      it_behaves_like 'a qubell api call', :post
    end

    describe '#put' do
      it_behaves_like 'a qubell api call', :put
    end

    describe '#delete' do
      it_behaves_like 'a qubell api call', :delete
    end

  end
end