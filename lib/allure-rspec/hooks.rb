module AllureRSpec
  module Hooks

    def self.included(cls)
      cls.extend OverrideHooksMethods
    end

    module OverrideHooksMethods
      include RSpec::Core::Hooks
      alias_method :old_extract_scope_from, :extract_scope_from
      alias_method :old_hooks, :hooks
      alias_method :old_find_hook, :find_hook

      SCOPES = [:each, :all, :suite, :step]

      def hooks
        if @__hooks.nil?
          @__hooks ||= old_hooks
          [:before, :after].each { |scope|
            @__hooks[scope][:step] = HookCollection.new
          }
        end
        @__hooks
      end

      def before_step_hooks_for(example)
        HookCollection.new(parent_groups.reverse.map { |a| a.hooks[:before][:step] }.flatten).for(example)
      end

      def after_step_hooks_for(example)
        HookCollection.new(parent_groups.map { |a| a.hooks[:after][:step] }.flatten).for(example)
      end

      def find_hook(hook, scope, example_or_group, initial_procsy)
        case [hook, scope]
          when [:before, :step]
            before_step_hooks_for(example_or_group)
          when [:after, :step]
            after_step_hooks_for(example_or_group)
          else
            old_find_hook(hook, scope, example_or_group, initial_procsy)
        end
      end

      def extract_scope_from(args)
        if SCOPES.include?(args.first)
          args.shift
        else
          old_extract_scope_from(args)
        end
      end
    end
  end
end

