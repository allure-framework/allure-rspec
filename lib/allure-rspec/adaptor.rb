module AllureRSpec
  module Adaptor
    def self.included(base)
      base.send :include, AllureRSpec::DSL
      if RSpec.configuration.formatters.find_all {|f| f.is_a?(AllureRSpec::Formatter)}.empty?
        RSpec.configuration.add_formatter(AllureRSpec::Formatter)
      end
    end
  end
end

