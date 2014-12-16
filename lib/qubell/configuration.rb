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
    attr_accessor :endpoint, :api_version, :username, :password

    def initialize
      @endpoint = 'https://express.qubell.com'
      @api_version = '1'
    end

    def to_s
      %({"endpoint": "#{@endpoint}","api_version": "#{@api_version}",) +
        %("username": "#{@username}","password": "#{@password}"})
    end
  end
end
