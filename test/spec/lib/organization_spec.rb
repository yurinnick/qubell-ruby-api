require File.dirname(__FILE__) + '/../spec_helper'
require 'json'

module Qubell
  describe Organization do
    let(:config) { FactoryGirl.build :configuration }
    let(:org) { FactoryGirl.build :organization }
    let(:apps) { FactoryGirl.build_list(:application, 1) }

    before :each do
      stub_request(:get,
                   "#{config.endpoint}/api/#{config.api_version}/" +
                       "organizations/#{org.id}/applications")
        .to_return(
            status: 200,
            body: apps.to_json,
            headers: { :'Content-type' => 'application/json' })
    end

    describe '#applications' do
      it 'return array of applications' do
        expect(org.applications).to eq(apps)
      end
    end
  end
end
