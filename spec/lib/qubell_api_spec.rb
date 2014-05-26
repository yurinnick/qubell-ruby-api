# Encoding: utf-8

require 'webmock/rspec'
require 'spec_helper'
require 'qubell_api'

describe QubellAPI do
  describe '' do
    it 'does something' do

    end
  end
  it 'has default endpoint https://express.qubell.com' do
    qubell_api = QubellAPI.new(username: 'test', password: 'password')
    qubell_api.endpoint.should == 'https://express.qubell.com'
  end

  it 'has default api version 1' do
    qubell_api = QubellAPI.new(username: 'test', password: 'password')
    qubell_api.api_version.should == '1'
  end

  # if ""
end
