def processors(db_connection, tracker)
  []
end

namespace :event_sourcery do
  namespace :db do
    task migrate: :environment do
      database = EventSourcery::Postgres.config.event_store_database
      begin
        EventSourcery::Postgres::Schema.create_event_store(db: database)
      rescue StandardError => e
        puts "Could not create event store: #{e.class.name} #{e.message}"
      end
    end
  end

  namespace :processors do
    task setup: :environment do
      processors(<%= @application_name %>.projections_database, <%= @application_name %>.tracker).each(&:setup)
    end

    task reset: :environment do
      processors(<%= @application_name %>.projections_database, <%= @application_name %>.tracker).each(&:reset)
    end

    task run: :environment do
      puts "Starting Event Stream Processors"

      <%= @application_name %>.projections_database.disconnect

      $stdout.sync = true

      EventSourcery::EventProcessing::ESPRunner.new(
        event_processors: processors(<%= @application_name %>.projections_database, <%= @application_name %>.tracker),
        event_source: <%= @application_name %>.event_source
      ).start!
    end
  end
end

