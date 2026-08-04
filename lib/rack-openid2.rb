# For loading by bundler
require "version_gem"
require_relative "rack/openid/version"

Rack::OpenID::Version.class_eval do
  extend VersionGem::Basic
end

require_relative "rack/openid"
