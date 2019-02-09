module EventSourceryRails
  class InstallGenerator < ::Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def copy_initializer
      @application_name = Rails.application.class.parent.name
      template "initializer.rb", "config/initializers/event_sourcery.rb"
    end
  end
end
