# frozen_string_literal: true

# Keep the historical Rack middleware suite in the generated RSpec workflow
# until it is intentionally migrated. These files predate the `spec/` layout
# and use Rots' Minitest-compatible spec DSL.
# kettle-test passes its worker options through ARGV; Minitest's autorunner
# does not understand RSpec's arguments, so clear that transport detail before
# loading the historical support file. RSpec has already parsed its arguments.
ARGV.clear

require "minitest/autorun"
RSpec::Core::DSL.expose_example_group_alias_globally(:describe)
RSpec.configure do |config|
  config.include Minitest::Assertions
  config.before do
    self.assertions = 0
  end
  config.include Module.new {
    attr_accessor :assertions

    def skip(message = nil)
      RSpec::Core::Pending.mark_skipped!(RSpec.current_example, message)
      raise RSpec::Core::Pending::SkipDeclaredInExample, message
    end

    def _(value = nil, &block)
      Minitest::Expectation.new(block || value, self)
    end
  }
end

Dir[File.expand_path("../test/test_*.rb", __dir__)].sort.each do |path|
  require path
end
