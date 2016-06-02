require 'singleton'

module Rake
  module Env
    class InvalidScopeError < StandardError; end

    class Variables < Hash
      include Singleton

      attr_reader :scope

      def initialize
        reset!
      end

      def []=(key, value)
        at(scope)[key] = value
        super(key, value)
      end

      def at(scope_or_path)
        target_scope = scope_path_of(scope_or_path)
        @variables[target_scope] ||= {}
      end

      def in!(task_or_scope_or_path)
        path = scope_path_of(task_or_scope_or_path)

        unless scope == path
          reset
          @scope = path
          self.deep_merge! at('')

          pathes = path.to_s.split(':')
          stack = []

          while (p = pathes.shift)
            stack.push p
            ns = stack.join(':')
            self.deep_merge! at(ns)
          end
        end

        self
      end

      def on(scope_or_path)
        original_scope = scope.dup
        in! scope_path_of(scope_or_path)
        yield self
        in! original_scope
      end

      def reset
        clear
        merge! ENV.to_hash
      end

      def reset!
        @scope = ''
        @variables = Hash.new
        reset
      end

      def reload!
        in!(scope)
      end

      private
      def scope_path_of(object)
        case object
        when Rake::Task
          object.scope.path
        when Rake::Scope
          object.path
        when String, Symbol
          # TODO: check format
          object.to_s
        else
          raise InvalidScopeError, "unscopable object error. Object -> #{object}"
        end
      end
    end
  end
end
