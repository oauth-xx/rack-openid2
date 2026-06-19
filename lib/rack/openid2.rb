# frozen_string_literal: true

require "version_gem"
require_relative "openid2/version"

module Rack
  module Openid2
  end
end

Rack::Openid2::Version.class_eval do
  extend VersionGem::Basic
end
