require 'allure-ruby-adaptor-api'
require 'allure-rspec/version'
require 'allure-rspec/formatter'
require 'allure-rspec/adaptor'
require 'allure-rspec/dsl'
require 'allure-rspec/hooks'

module AllureRSpec
  module Config
    class << self
      attr_accessor :output_dir
      attr_accessor :clean_dir

      DEFAULT_OUTPUT_DIR = 'gen/allure-results'

      def output_dir
        @output_dir || DEFAULT_OUTPUT_DIR
      end

      def clean_dir?
        @clean_dir.nil? ? true : @clean_dir
      end
    end
  end

  class Context
    attr_accessor :rspec
  end

  class << self
    def context
      @context ||= Context.new
    end
  end

  class << self
    def configure(&block)
      yield Config
      AllureRubyAdaptorApi.configure { |c|
        c.output_dir = Config.output_dir
      }
    end
  end

end