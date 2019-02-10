require "event_sourcery/rails/railtie"

module EventSourcery
  module Rails
    autoload :Command, "event_sourcery/rails/command"
    autoload :CommandHandler, "event_sourcery/rails/command_handler"
  end
end
