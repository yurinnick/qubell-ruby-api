# Encoding: utf-8
# Qubell API wrapper
# @author Nikolay Yurin <yurinnick@outlook.com>

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'json'

# Main Qubell module
module Qubell
  # Class wrapper for HTTP requests
  class Base
    # @return [String] object id
    attr_reader :id
    # @return [String] object name
    attr_reader :name

    def initialize(args)
      if args[:id].nil?
        raise ArgumentError,
              "can't initialize #{self.class.name} without id"
      end

      @id = args[:id]
      @name = args[:name]
    end

    def to_json(options)
      to_hash.to_json(options)
    end

    def to_s
      %("id": "#{@id}", "name": "#{@name}")
    end

    def to_hash
      { id: @id, name: @name }
    end

    def ==(other)
      other.instance_of?(self.class) &&
        id == other.id &&
        name == other.name
    end
  end
end
