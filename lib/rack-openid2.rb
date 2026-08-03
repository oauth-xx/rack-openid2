# For loading by bundler
require_relative "rack/openid"
require "version_gem"
require_relative "rack/openid/version"

Rack::Version.class_eval do
  extend VersionGem::Basic
end
