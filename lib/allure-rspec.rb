require 'allure-ruby-adaptor-api'
require 'allure-rspec/version'
require 'allure-rspec/formatter'
require 'allure-rspec/adaptor'
require 'allure-rspec/dsl'
require 'allure-rspec/hooks'

module AllureRSpec
  include AllureRSpec::DSL

  module Config
    class << self
      attr_accessor :output_dir
      attr_accessor :clean_dir

      DEFAULT_OUTPUT_DIR = 'allure/data'

      def output_dir
        @output_dir || DEFAULT_OUTPUT_DIR
      end

      def clean_dir?
        @clean_dir || true
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
      AllureRubyApi.configure {|c|
        c.output_dir = Config.output_dir
      }
    end
  end

end