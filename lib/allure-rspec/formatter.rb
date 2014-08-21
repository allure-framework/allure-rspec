require 'rspec/core/formatters/base_formatter'
require 'fileutils'

module AllureRSpec

  class Formatter < RSpec::Core::Formatters::BaseFormatter

    NOTIFICATIONS = [:example_group_started, :example_group_finished, :example_started,
                     :example_failed, :example_passed, :example_pending, :start, :stop]
    ALLOWED_LABELS = [:feature, :story, :severity, :language, :framework]

    def example_failed(example)
      AllureRubyAdaptorApi::Builder.stop_test(
          example.example.example_group.description,
          example.example.description.to_s,
          example.example.execution_result
      )
    end

    def example_group_finished(group)
      AllureRubyAdaptorApi::Builder.stop_suite(group.group.description.to_s)
    end

    def example_group_started(group)
      AllureRubyAdaptorApi::Builder.start_suite(group.group.description.to_s, labels(group))
    end

    def example_passed(example)
      AllureRubyAdaptorApi::Builder.stop_test(
          example.example_group.description,
          example.description.to_s,
          example.execution_result.merge(:caller => example.metadata[:caller])
      )
    end

    def example_pending(example)
    end

    def example_started(example)
      suite = example.example.example_group.description
      test = example.example.description.to_s
      AllureRubyAdaptorApi::Builder.start_test(suite, test, labels(example))
    end

    def start(example_count)
      dir = Pathname.new(AllureRSpec::Config.output_dir)
      if AllureRSpec::Config.clean_dir?
        puts "Cleaning output directory '#{dir}'..."
        FileUtils.rm_rf(dir)
      end
      FileUtils.mkdir_p(dir)
    end

    def stop(notify)
      AllureRubyAdaptorApi::Builder.build!
    end

    private

    def metadata(example_or_group)
      (example_or_group.respond_to? :group) ?
          example_or_group.group.metadata :
          example_or_group.example.metadata
    end

    def labels(example_or_group)
      ALLOWED_LABELS.
          map { |label| [label, metadata(example_or_group)[label]] }.
          find_all { |value| !value[1].nil? }.
          inject({}) { |res, value| res.merge(value[0] => value[1]) }
    end

  end
end
