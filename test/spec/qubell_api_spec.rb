require File.dirname(__FILE__) + '/spec_helper'

module Qubell
  describe API do
    let(:config) { FactoryGirl.build :configuration }
    let(:client) { FactoryGirl.build :client }
    let(:orgs) { FactoryGirl.build_list(:organization, 1) }

    before :each do
      stub_request(:get, "#{config.endpoint}/organizations")
        .to_return(
          status: 200,
          body: orgs.to_json,
          headers: { :'Content-type' => 'application/json' }
        )
    end

    describe '#organizations' do
      it 'return array of organizations' do
        expect(client.organizations).to eq(orgs)
      end
    end
  end
end
