# Encoding: utf-8
# Qubell application class
# @author Nikolay Yurin <yurinnick@outlook.com>

require 'qubell/base'
require 'qubell/revision'
require 'qubell/api_call'

# Main Qubell module
module Qubell
  # Qubell application class
  class Application < Base
    # Get list of all named revisions for given application.
    # @return [Array<Qubell::Revision>] revisions info
    def revisions
      revs = []
      Qubell::APICall.get("/applications/#{@id}/revisions").each do |rev|
        revs << Qubell::Revision.new(rev)
      end
      revs
    end

    # Get the application instance status.
    # @param [String] path path to the new manifest file
    # @return [Hashes{String => String}] instances status info
    def update(path)
      put("/applications/#{@id}/manifest",
          File.read(path),
          content_type: 'application/x-yaml')
    end

    def launch(args)

    end
  end
end
