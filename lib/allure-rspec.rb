require 'allure-rspec/version'
require 'allure-rspec/formatter'
require 'allure-rspec/adaptor'
require 'allure-rspec/dsl'
require 'allure-rspec/builder'

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

  class << self
    def configure(&block)
      yield Config
    end
  end

end