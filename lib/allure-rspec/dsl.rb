require 'digest'
require 'mimemagic'
module AllureRSpec
  module DSL
    module Example

      def current_step
        if defined? @@__current_step
          @@__current_step
        else
          nil
        end
      end

      def step(step, &block)
        suite = __description(metadata[:example_group])
        test = __description(metadata)
        begin
          AllureRubyAdaptorApi::Builder.start_step(suite, test, step)
          __with_step step, &block
          AllureRubyAdaptorApi::Builder.stop_step(suite, test, step)
        rescue Exception => e
          AllureRubyAdaptorApi::Builder.stop_step(suite, test, step, :failed)
          raise e
        end
      end


      def attach_file(title, file, opts = {})
        suite = __description(metadata[:example_group])
        test = __description(metadata)
        step = current_step
        AllureRubyAdaptorApi::Builder.add_attachment suite, test, opts.merge(:title => title, :file => file, :step => step)
      end

      private

      def __description(data)
        data[:full_description] || data[:description]
      end

      def __mutex
        @@__mutex ||= Mutex.new
      end

      def __with_step(step, &block)
        __mutex.synchronize do
          begin
            @@__current_step = step
            AllureRSpec.context.rspec.hooks.send :run, :before, :step, self
            yield self
          ensure
            AllureRSpec.context.rspec.hooks.send :run, :after, :step, self
            @@__current_step = nil
          end
        end
      end
    end
  end
end

