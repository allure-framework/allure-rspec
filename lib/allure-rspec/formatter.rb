require 'pathname'
require 'uuid'

module AllureRSpec

  class Formatter < RSpec::Core::Formatters::BaseFormatter

    def example_failed(example)
      AllureRSpec::Builder.stop_test(
          example.metadata[:example_group][:description_args].first,
          example.metadata[:description],
          example.metadata[:execution_result].merge(:caller => example.metadata[:caller])
      )
      super
    end

    def example_group_finished(group)
      AllureRSpec::Builder.stop_suite(group.metadata[:example_group][:description_args].first)
      super
    end

    def example_group_started(group)
      AllureRSpec::Builder.start_suite(group.metadata[:example_group][:description_args].first)
      super
    end

    def example_passed(example)
      AllureRSpec::Builder.stop_test(
          example.metadata[:example_group][:description_args].first,
          example.metadata[:description],
          example.metadata[:execution_result].merge(:caller => example.metadata[:caller])
      )
      super
    end

    def example_pending(example)
      super
    end

    def example_started(example)
      suite = example.metadata[:example_group][:description_args].first
      test = example.metadata[:description]
      AllureRSpec::Builder.start_test(suite, test)
      super
    end

    def stop
      AllureRSpec::Builder.each_suite_build do |suite, xml|
        dir = Pathname.new(AllureRSpec::Config.output_dir)
        FileUtils.rm_rf(dir)
        FileUtils.mkdir_p(dir)
        File.open(dir.join("#{UUID.new.generate}.xml"), 'w+') do |file|
          file.write(xml)
        end
      end
      super
    end

  end
end
