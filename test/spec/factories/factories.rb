require 'qubell_api'
require 'qubell/application'
require 'qubell/configuration'
require 'qubell/organization'
require 'qubell/revision'

FactoryGirl.define do
  factory :client, class: Qubell::API

  factory :configuration, class: Qubell::Configuration do
    username 'username'
    password 'password'
  end

  factory :organization, class: Qubell::Organization do
    initialize_with { new('id' => SecureRandom.hex(12), 'name' => 'org') }
  end

  factory :application, class: Qubell::Application do
    initialize_with { new('id' => SecureRandom.hex(12), 'name' => 'app') }
  end

  factory :revision, class: Qubell::Revision do
    initialize_with { new('id' => SecureRandom.hex(12), 'name' => 'rev') }
  end
end
