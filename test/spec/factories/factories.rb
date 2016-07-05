require 'qubell_api'

FactoryGirl.define do
  factory :client, class: Qubell::API

  factory :configuration, class: Qubell::Configuration do
    username 'username'
    password 'password'
  end

  factory :organization, class: Qubell::Resources::Organization do
    initialize_with { new(id: SecureRandom.hex(12), name: 'org') }
  end

  factory :application, class: Qubell::Resources::Application do
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

  factory :revision, class: Qubell::Resources::Revision do
    initialize_with { new(id: SecureRandom.hex(12), name: 'rev') }
  end

  factory :instance, class: Qubell::Resources::Instance do
    initialize_with do
      new(
        id: SecureRandom.hex(12),
        name: 'instance',
        environment: SecureRandom.hex(12),
        revision: SecureRandom.hex(12)
      )
    end
  end

  factory :environment, class: Qubell::Resources::Environment do
    initialize_with do
      new(id: SecureRandom.hex(12), name: 'env', isDefault: true)
    end
  end
end
