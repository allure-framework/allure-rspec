require 'rspec/core/formatters/base_formatter'
require 'fileutils'

module AllureRSpec

  class Formatter < RSpec::Core::Formatters::BaseFormatter

    NOTIFICATIONS = [:example_group_started, :example_group_finished, :example_started,
                     :example_failed, :example_passed, :example_pending, :start, :stop]
    ALLOWED_LABELS = [:feature, :story, :severity, :language, :framework]

    def example_failed(notification)
      res = notification.example.execution_result
      status = res.exception.is_a?(RSpec::Expectations::ExpectationNotMetError) ? :failed : :broken
      stop_test(notification.example, :exception => res.exception, :status => status)
    end

    def example_group_finished(notification)
      AllureRubyAdaptorApi::Builder.stop_suite(description(notification.group).to_s)
    end

    def example_group_started(notification)
      AllureRubyAdaptorApi::Builder.start_suite(description(notification.group).to_s, labels(notification))
    end

    def example_passed(notification)
      stop_test(notification.example)
    end

    def example_pending(notification)
      stop_test(notification.example)
    end

    def example_started(notification)
      suite = description(notification.example.example_group).to_s
      test = description(notification.example).to_s
      AllureRubyAdaptorApi::Builder.start_test(suite, test, labels(notification))
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

    def description(data, attr = :full_description)
      ((data.respond_to?(attr)) ?
          data.send(attr) : data.metadata[attr]) ||
          description(data, :description)
    end

    def stop_test(example, opts = {})
      res = example.execution_result
      AllureRubyAdaptorApi::Builder.stop_test(
          description(example.example_group).to_s,
          description(example).to_s,
          {
              :status => res.status,
              :finished_at => res.finished_at,
              :started_at => res.started_at
          }.merge(opts)
      )
    end

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
