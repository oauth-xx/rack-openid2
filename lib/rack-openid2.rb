# For loading by bundler
require "version_gem"
require_relative "rack/openid/version"

require_relative "rack/openid"

Rack::Version.class_eval do
  extend VersionGem::Basic
end
