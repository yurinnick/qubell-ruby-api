require File.dirname(__FILE__) + '/../spec_helper'

module Qubell
  describe Application do
    let(:config) { FactoryGirl.build :configuration }
    let(:org) { FactoryGirl.build :organization }
    let(:env) { FactoryGirl.build :environment }
    let(:app) { FactoryGirl.build :application, org_id: org.id }
    let(:revs) { FactoryGirl.build_list(:revision, 1) }
    let(:instance) { FactoryGirl.build :instance }
    let(:instance_info) do
      { applicationId: app.id }
    end
    let(:app_url) { "#{config.endpoint}/applications/#{app.id}" }
    let(:manifest) do
      {
        application: {
          components: {}
        }
      }
    end
    let(:version) { '1' }

    describe '#revisions' do
      before do
        stub_request(:get, "#{app_url}/revisions")
          .to_return(
            status: 200,
            body: revs.to_json,
            headers: { :'Content-type' => 'application/json' })
      end

      it 'return array of revisions' do
        expect(app.revisions).to match_array(revs)
      end
    end

    describe '#update' do
      before do
        stub_request(:put, "#{app_url}/manifest")
          .with(
            body: manifest.to_yaml,
            headers: { :'Content-type' => 'application/x-yaml' })
          .to_return(
            status: 200,
            body: { version: version }.to_json,
            headers: { :'Content-type' => 'application/json' })
      end

      it 'return new version number' do
        expect(app.update(manifest.to_yaml)).to eq(version)
      end
    end

    describe '#instances' do
      before do
        stub_request(:get, "#{config.endpoint}/organizations")
          .to_return(
            status: 200,
            body: [org].to_json,
            headers: { :'Content-type' => 'application/json' })

        stub_request(:get, "#{config.endpoint}/organizations/#{org.id}/environments")
        .to_return(
            status: 200,
            body: [env].to_json,
            headers: { :'Content-type' => 'application/json' })

        stub_request(:get, "#{config.endpoint}/environments/#{env.id}/instances")
        .to_return(
            status: 200,
            body: [instance].to_json,
            headers: { :'Content-type' => 'application/json' })

        stub_request(:get, "#{config.endpoint}/instances/#{instance.id}")
        .to_return(
          status: 200,
          body: instance_info.to_json,
          headers: { :'Content-type' => 'application/json' })
      end
      it 'return array of instances' do
        expect(app.instances).to match_array([instance])
      end
    end

    describe '#launch' do
      let(:new_instance) { FactoryGirl.build :instance }
      let(:parameters) { {} }
      before do
        allow(app).to receive(:instances) { [new_instance] }

        stub_request(:put, "#{app_url}/launch")
        .with(
            body: parameters.to_json,
            headers: { :'Content-type' => 'application/json' })
        .to_return(
            status: 200,
            body: { id: new_instance.id }.to_json,
            headers: { :'Content-type' => 'application/json' })
      end
      it 'return new instance id' do
        expect(app.launch(parameters)).to eq(new_instance)
      end
    end
  end
end
