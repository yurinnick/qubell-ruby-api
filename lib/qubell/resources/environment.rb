# Encoding: utf-8
# Qubell application class
# @author Nikolay Yurin <yurinnick@outlook.com>

require 'yaml'
require 'qubell_api'

module Qubell
  module Resources
    # Implements Qubell environment interface
    class Environment < Base
      attr_reader :is_default

      def initialize(args)
        super
        @is_default = args[:isDefault]
      end

      def policies
        Qubell::APICall.get("/environments/#{@id}")[:policies]
      end

      # noinspection RubyStringKeysInHashInspection
      def policies=(value)
        Qubell::APICall.put("/environments/#{@id}",
                            { policies: value }.to_yaml,
                            content_type: 'application/x-yaml')
      rescue Qubell::Exceptions::ExecutionError
        raise Qubell::Exceptions::FormatError
      end

      def markers
        Qubell::APICall
          .get("/environments/#{@id}/markers")[:markers].map { |m| m[:name] }
      end

      def markers=(value)
        Qubell::APICall.put("/environments/#{@id}/markers",
                            { markers: value.each { |v| { name: v } } }.to_json,
                            content_type: 'application/json')
      rescue Qubell::Exceptions::ExecutionError
        raise Qubell::Exceptions::FormatError
      end

      def properties
        Qubell::APICall.get("/environments/#{@id}/properties")[:properties]
      end

      def properties=(value)
        Qubell::APICall.put("/environments/#{@id}/properties",
                            { properties: value }.to_json,
                            content_type: 'application/json')
      rescue Qubell::Exceptions::ExecutionError
        raise Qubell::Exceptions::FormatError
      end

      def instances
        Qubell::APICall.get("/environments/#{@id}/instances").map do |inst|
          Qubell::Resources::Instance.new(inst)
        end
      end
    end
  end
end
