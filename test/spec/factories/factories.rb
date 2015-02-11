require 'qubell_api'
require 'qubell/application'
require 'qubell/configuration'
require 'qubell/organization'
require 'qubell/revision'
require 'qubell/environment'
require 'qubell/instance'

FactoryGirl.define do
  factory :client, class: Qubell::API

  factory :configuration, class: Qubell::Configuration do
    username 'username'
    password 'password'
  end

  factory :organization, class: Qubell::Organization do
    initialize_with { new(id: SecureRandom.hex(12), name: 'org') }
  end

  factory :application, class: Qubell::Application do
    transient do
      org_id SecureRandom.hex(12)
    end
    initialize_with do
      new(
          id: SecureRandom.hex(12),
          name: 'app',
          organization: org_id
      )
    end
  end

  factory :revision, class: Qubell::Revision do
    initialize_with { new(id: SecureRandom.hex(12), name: 'rev') }
  end

  factory :instance, class: Qubell::Instance do
    initialize_with do
      new(
          id: SecureRandom.hex(12),
          name: 'instance',
          environment: SecureRandom.hex(12),
          revision: SecureRandom.hex(12))
    end
  end

  factory :environment, class: Qubell::Environment do
    initialize_with do
      new(id: SecureRandom.hex(12), name: 'env', isDefault: true)
    end
  end
end
