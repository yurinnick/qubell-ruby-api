# Main Qubell module
module Qubell
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield configuration
  end

  # Store configuration settings
  class Configuration
    attr_accessor :domain, :api_version, :username, :password
    attr_reader :endpoint

    def initialize
      @domain = 'https://express.qubell.com'
      @api_version = '1'
    end

    def endpoint
      "#{@domain}/api/#{@api_version}"
    end

    def to_s
      %({"domain": "#{@domain}","api_version": "#{@api_version}",) +
        %("username": "#{@username}","password": "#{@password}"})
    end
  end
end
