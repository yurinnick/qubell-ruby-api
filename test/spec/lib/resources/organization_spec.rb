require File.dirname(__FILE__) + '/../spec_helper'
require 'json'

module Qubell
  describe Resources::Organization do
    let(:config) { FactoryGirl.build :configuration }
    let(:org) { FactoryGirl.build :organization }
    let(:apps) { FactoryGirl.build_list(:application, 1) }

    describe '#applications' do
      before do
        stub_request(:get,
                     "#{config.endpoint}/organizations/#{org.id}/applications")
          .to_return(
            status: 200,
            body: apps.to_json,
            headers: { :'Content-type' => 'application/json' }
          )
      end
      it 'return array of applications' do
        expect(org.applications).to match_array(apps)
      end
    end

    describe '#new' do
      before do
        stub_request(:get, "#{config.endpoint}/organizations")
          .to_return(
            status: 200,
            body: [org].to_json,
            headers: { :'Content-type' => 'application/json' }
          )
      end
      it 'return organization' do
        expect(org).to eq(Qubell::Resources::Organization.new(org.to_hash))
      end
    end
  end
end
