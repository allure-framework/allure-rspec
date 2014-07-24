require 'digest'
require 'mimemagic'
module AllureRSpec
  module DSL

    def __mutex
      @@__mutex ||= Mutex.new
    end

    def current_step
      if defined? @@__current_step
        @@__current_step
      else
        nil
      end
    end

    def __with_step(step, &block)
      __mutex.synchronize do
        begin
          @@__current_step = step
          Config.rspec.send :run_hook, :before, :step, example
          yield
        ensure
          Config.rspec.send :run_hook, :after, :step, example
          @@__current_step = nil
        end
      end
    end

    def step(step, &block)
      suite = self.example.metadata[:example_group][:description_args].first
      test = self.example.metadata[:description]
      AllureRSpec::Builder.start_step(suite, test, step)
      __with_step step, &block
      AllureRSpec::Builder.stop_step(suite, test, step)
    end

    def attach_file(title, file)
      step = current_step
      dir = Pathname.new(AllureRSpec::Config.output_dir)
      FileUtils.mkdir_p(dir)
      file_extname = File.extname(file.path.downcase)
      type = MimeMagic.by_path(file.path) || "text/plain"
      attachment = dir.join("#{Digest::SHA256.file(file.path).hexdigest}-attachment#{(file_extname.empty?) ? '' : file_extname}")
      FileUtils.cp(file.path, attachment)
      suite = self.example.metadata[:example_group][:description_args].first
      test = self.example.metadata[:description]
      AllureRSpec::Builder.add_attachment(suite, test, {
          :type => type,
          :title => title,
          :source => attachment.basename,
          :size => File.stat(attachment).size
      }, step)
    end
  end
end

