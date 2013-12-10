module AllureRSpec
  module DSL

    ALLOWED_ATTACH_EXTS = %w[txt html xml png jpg json]

    def __mutex
      @@__mutex ||= Mutex.new
    end

    def __current_step
      if defined? @@__current_step
        @@__current_step
      else
        nil
      end
    end

    def __with_step(step, &block)
      __mutex.synchronize do
        @@__current_step = step
        yield
        @@__current_step = nil
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
      step = __current_step
      suite = self.example.metadata[:example_group][:description_args].first
      test = self.example.metadata[:description]
      type = :other
      file_extname = File.extname(file.path.downcase)
      type = file_extname if ALLOWED_ATTACH_EXTS.include?(file_extname)
      AllureRSpec::Builder.add_attachment(suite, test, {:type => type, :title => title, :source => file.path}, step)
    end
  end
end

