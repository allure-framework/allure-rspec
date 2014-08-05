require 'digest'
require 'mimemagic'
module AllureRSpec
  module DSL
    def current_step
      if defined? @@__current_step
        @@__current_step
      else
        nil
      end
    end

    def step(step, &block)
      suite = self.example.metadata[:example_group][:description_args].first
      test = self.example.metadata[:description]
      AllureRubyAdaptorApi::Builder.start_step(suite, test, step)
      __with_step step, &block
      AllureRubyAdaptorApi::Builder.stop_step(suite, test, step)
    end

    def attach_file(title, file, opts = {})
      suite = self.example.metadata[:example_group][:description_args].first
      test = self.example.metadata[:description]
      step = current_step
      AllureRubyAdaptorApi::Builder.add_attachment suite, test, opts.merge(:file => file, :title => title, :step => step)
    end

    private

    def __mutex
      @@__mutex ||= Mutex.new
    end

    def __with_step(step, &block)
      __mutex.synchronize do
        begin
          @@__current_step = step
          AllureRSpec.context.rspec.send :run_hook, :before, :step, example
          yield
        ensure
          AllureRSpec.context.rspec.send :run_hook, :after, :step, example
          @@__current_step = nil
        end
      end
    end
  end
end

