module AllureRSpec
  module Hooks

    def self.included(cls)
      cls.extend OverrideHooksMethods
    end

    module OverrideHooksMethods
      include RSpec::Core::Hooks

      alias_method :old_hooks, :hooks

      def hooks
        if @__hooks.nil?
          old = old_hooks
          @__hooks ||= OverridenHookCollections.new(old.instance_variable_get(:@owner), old.instance_variable_get(:@data))
          [:before, :after].each { |scope|
            @__hooks[scope][:step] = HookCollection.new
          }
        end
        @__hooks
      end

      private

      class OverridenHookCollections < RSpec::Core::Hooks::HookCollections
        private

        SCOPES = [:example, :context, :suite, :step]

        def before_step_hooks_for(example)
          RSpec::Core::Hooks::HookCollection.new(RSpec::Core::FlatMap.flat_map(@owner.parent_groups.reverse) do |a|
            a.hooks[:before][:step]
          end).for(example)
        end

        def after_step_hooks_for(example)
          RSpec::Core::Hooks::HookCollection.new(RSpec::Core::FlatMap.flat_map(@owner.parent_groups) do |a|
            a.hooks[:after][:step]
          end).for(example)
        end

        def find_hook(hook, scope, example_or_group, initial_procsy)
          case [hook, scope]
            when [:before, :step]
              before_step_hooks_for(example_or_group)
            when [:after, :step]
              after_step_hooks_for(example_or_group)
            else
              super(hook, scope, example_or_group, initial_procsy)
          end
        end

        def known_scope?(scope)
          SCOPES.include?(scope) || super(scope)
        end

      end
    end
  end
end

