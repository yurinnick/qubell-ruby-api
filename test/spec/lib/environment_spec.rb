require File.dirname(__FILE__) + '/../spec_helper'
require 'yaml'

module Qubell
  describe Environment do
    let(:config) { FactoryGirl.build :configuration }
    let(:env) { FactoryGirl.build :environment }
    let(:env_url) { "#{config.endpoint}/environments/#{env.id}" }
    let(:instances) { FactoryGirl.build_list(:instance, 1) }
    # noinspection RubyStringKeysInHashInspection
    let(:policies) do
      { policies: { testkey: 'test-value' } }
    end
    # noinspection RubyStringKeysInHashInspection
    let(:properties) do
      { properties: [{ name: 'test',
                       value: 'testvalue',
                       type: 'string'
                     }]
      }
    end
    # noinspection RubyStringKeysInHashInspection
    let(:markers) do
      { markers: [{ name: 'test-marker-1' },
                  { name: 'test-marker-2' }] }
    end

    describe '#policies' do
      before do
        stub_request(:get, env_url)
          .to_return(
            status: 200,
            body: policies.to_yaml,
            headers: { :'Content-type' => 'application/x-yaml' })
      end
      it 'return array of policies' do
        expect(env.policies).to match_array(policies[:policies])
      end
    end

    describe '#policies=' do
      before do
        stub_request(:put, env_url)
          .with(
            body: policies.to_yaml,
            headers: { :'Content-type' => 'application/x-yaml' })
          .to_return do |request|
          stub_request(:get, env_url)
            .to_return(status: 200,
                       body: request.body,
                       headers: { :'Content-type' => 'application/x-yaml' })
          { status: 200 }
        end
      end
      it 'return array of policies' do
        env.policies = policies[:policies]
        expect(env.policies).to match_array(policies[:policies])
      end
    end

    describe '#properties' do
      before do
        stub_request(:get, "#{env_url}/properties")
          .to_return(
            status: 200,
            body: properties.to_json,
            headers: { :'Content-type' => 'application/json' })
      end
      it 'return array of properties' do
        expect(env.properties).to match_array(properties[:properties])
      end
    end

    describe '#properties=' do
      before do
        stub_request(:put, "#{env_url}/properties")
          .with(
            body: properties.to_json,
            headers: { :'Content-type' => 'application/json' })
          .to_return do |request|
          stub_request(:get, "#{env_url}/properties")
            .to_return(status: 200,
                       body: request.body,
                       headers: { :'Content-type' => 'application/json' })
          { status: 200 }
        end
      end
      it 'can set value' do
        env.properties = properties[:properties]
        expect(env.properties).to match_array(properties[:properties])
      end
    end

    describe '#markers' do
      before do
        stub_request(:get, "#{env_url}/markers")
          .to_return(
            status: 200,
            body: markers.to_json,
            headers: { :'Content-type' => 'application/json' })
      end
      it 'return array of markers' do
        expect(env.markers).to match_array(markers[:markers].map { |m| m[:name] })
      end
    end

    describe '#markers=' do
      before do
        stub_request(:put, "#{env_url}/markers")
          .with(
            body: markers.to_json,
            headers: { :'Content-type' => 'application/json' })
          .to_return do |request|
          stub_request(:get, "#{env_url}/markers")
            .to_return(status: 200,
                       body: request.body,
                       headers: { :'Content-type' => 'application/json' })
          { status: 200 }
        end
      end
      it 'can set value' do
        env.markers = markers[:markers]
        expect(env.markers).to match_array(markers[:markers].map { |m| m[:name] })
      end
    end
  end
end
