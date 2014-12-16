# Encoding: utf-8

shared_examples 'parsed json response' do
  before do
    stub_request(:get, url).to_return(
    status: 200,
    body: data,
    headers: { :'Content-type' => 'application/json' })
  end
  it { should match_array(JSON.load data) }
end

shared_examples 'invalid credentials response' do
  before { stub_request(:get, url).to_return(status: 401) }
  it 'should return AuthenticationError(invalid credentials)' do
    expect { subject }.to raise_error(AuthenticationError, 'invalid credentials')
  end
end

shared_examples 'invalid permissions response' do
  before { stub_request(:get, url).to_return(status: 403) }
  it 'should return PermissionsError(insufficient privileges)' do
    expect { subject }.to raise_error(PermissionsError, 'insufficient privileges')
  end
end

shared_examples 'unexisting resource response' do
  before { stub_request(:get, url).to_return(status: 404) }
  it 'should return ArgumentError(resource doesn’t exist)' do
    expect { subject }.to raise_error(ArgumentError, 'resource doesn’t exist')
  end
end

shared_examples 'workflow running error response' do
  before { stub_request(:get, url).to_return(status: 409) }
  it 'should return ArgumentError(another workflow is already running)' do
    expect { subject }.to raise_error(ArgumentError, 'another workflow is already running')
  end
end

shared_examples 'common_get_method' do
  context 'with valid credentials' do
    it_behaves_like 'parsed json response'
  end

  context 'with invalid credentials' do
    it_behaves_like 'invalid credentials response'
  end

  context 'without permissions' do
    it_behaves_like 'invalid permissions response'
  end
end
