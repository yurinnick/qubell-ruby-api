require 'rspec'

module Qubell
  describe Resources::Revision do
    let(:config) { FactoryGirl.build :configuration }
    let(:revision) { FactoryGirl.build :revision }
    let(:revision_url) { "#{config.endpoint}/revisions/#{revision.id}" }
    let(:instances) { FactoryGirl.build_list(:instance, 2) }

    describe '#instances' do
      before do
        stub_request(:get, "#{revision_url}/instances")
          .to_return(
            status: 200,
            body: instances.to_json,
            headers: { :'Content-type' => 'application/json' }
          )
      end
      it 'return array of application instances' do
        expect(revision.instances).to match_array(instances)
      end
    end
  end
end
