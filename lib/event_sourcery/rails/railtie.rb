module EventSourcery
  module Rails
    class Railtie < ::Rails::Railtie
      generators do
        require 'event_sourcery/rails/generators/install_generator'
      end
    end
  end
end
