module AllureRSpec
  module Hooks

    def self.included(cls)
      cls.extend OverrideHooksMethods
    end

    module OverrideHooksMethods
      include RSpec::Core::Hooks

      alias_method :old_hooks, :hooks

      def hooks
        @__hooks ||= OverridenHookCollections.new(old_hooks)
      end

      private

      class OverridenHookCollections < RSpec::Core::Hooks::HookCollections
        def initialize(original)
          super(original.instance_eval("@owner"), original.instance_eval("@filterable_item_repo_class"))
          [:@before_example_hooks, :@after_example_hooks, :@before_context_hooks, :@after_context_hooks, :@around_example_hooks].each { |var|
            instance_variable_set(var, original.instance_eval("#{var}"))
          }
          @before_step_hooks = nil
          @after_step_hooks = nil
        end

        def run(position, scope, example_or_group)
          if scope == :step
            run_owned_hooks_for(position, scope, example_or_group)
          else
            super
          end
        end

        protected

        # TODO: This code is highly related to the RSpec internals.
        # It should be supported with every new RSpec version
        def matching_hooks_for(position, scope, example_or_group)
          if scope == :step
            repo = hooks_for(position, scope) || example_or_group.example_group.hooks.hooks_for(position, scope)
            metadata = case example_or_group
                         when RSpec::Core::ExampleGroup then
                           example_or_group.class.metadata
                         else
                           example_or_group.metadata
                       end
            repo.nil? ? EMPTY_HOOK_ARRAY : repo.items_for(metadata)
          else
            super
          end
        end

        def hooks_for(position, scope)
          if scope == :step
            position == :before ? @before_step_hooks : @after_step_hooks
          else
            super
          end
        end

        def ensure_hooks_initialized_for(position, scope)
          if scope == :step
            if position == :before
              @before_step_hooks ||= @filterable_item_repo_class.new(:all?)
            else
              @after_step_hooks ||= @filterable_item_repo_class.new(:all?)
            end
          else
            super
          end
        end

        SCOPES = [:example, :context, :step]

        def known_scope?(scope)
          SCOPES.include?(scope) || super(scope)
        end

      end
    end
  end
end

