module EventSourcery
  module Rails
    module CommandHandler

      def self.included(klass)
        klass.extend ClassMethods
      end

      def call(command)
        return unless self.class.command_events.has_key?(command.class)
        instance_exec command, &self.class.command_events[command.class]
      end

      private

      module ClassMethods
        def command_events
          @command_events ||= {}
        end

        def on(command, &block)
          self.command_events[command] = block
        end
      end
    end
  end
end
