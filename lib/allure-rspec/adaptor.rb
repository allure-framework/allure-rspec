module AllureRSpec
  module Adaptor
    def self.included(base)
      base.send :include, AllureRSpec::DSL
      RSpec.configuration.add_formatter(AllureRSpec::Formatter)
    end
  end
end

