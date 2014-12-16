require File.dirname(__FILE__) + '/../spec_helper'

module Qubell
  describe Application do
    let(:config) { FactoryGirl.build :configuration }
    let(:app) { FactoryGirl.build :application }
    let(:revs) { FactoryGirl.build_list(:revision, 1)}

    before :each do
      stub_request(:get,
                   "#{config.endpoint}/api/#{config.api_version}/" +
                       "applications/#{app.id}/revisions")
      .to_return(
          status: 200,
          body: revs.to_json,
          headers: { :'Content-type' => 'application/json' })
    end

    describe '#revisions' do
      it 'return array of revisions' do
        expect(app.revisions).to eq(revs)
      end
    end
    # describe '#update' do
    #   it 'return array of applications' do
    #     expect(org.applications).to eq(apps)
    #   end
    # end
  end
end