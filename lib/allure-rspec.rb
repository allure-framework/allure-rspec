require 'allure-rspec/version'
require 'allure-rspec/formatter'
require 'allure-rspec/adaptor'
require 'allure-rspec/dsl'
require 'allure-rspec/builder'
require 'allure-rspec/hooks'

module AllureRSpec
  include AllureRSpec::DSL

  module Config
    class << self
      attr_accessor :output_dir

      DEFAULT_OUTPUT_DIR = 'allure/data'

      def output_dir
        @output_dir || DEFAULT_OUTPUT_DIR
      end
    end
  end

  class Context
    attr_accessor :rspec

    def rspec
      @rspec
    end
  end

  class << self
    def context
      @context ||= Context.new
    end
  end

  class << self
    def configure(&block)
      yield Config
    end
  end

end