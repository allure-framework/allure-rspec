module AllureRSpec
  module Adaptor
    def self.included(base)
      AllureRSpec.context.rspec = base
      base.send :include, AllureRSpec::DSL
      if RSpec::Core::Formatters::Loader.formatters.keys.find_all { |f| f == AllureRSpec::Formatter }.empty?
        RSpec::Core::Formatters.register AllureRSpec::Formatter, *AllureRSpec::Formatter::NOTIFICATIONS
        RSpec.configuration.add_formatter(AllureRSpec::Formatter)
      end
      RSpec::Core::ExampleGroup.send :include, AllureRSpec::Hooks
      RSpec::Core::Example.send :include, AllureRSpec::DSL::Example
    end
  end
end

