require "rails_helper"
require "event_sourcery/rails/generators/install_generator"

module MyApplication
  App = Class.new
end

module EventSourceryRails
  describe InstallGenerator, type: :generator do
    around do |example|
      orig_app = Rails.application
      Rails.application = MyApplication::App.new
      example.run
      Rails.application = orig_app
    end

    before do
      generator = run_generator %w(event_sourcery_rails:install)
    end

    context "copy_initializer" do
      let(:initializer_file) { file('config/initializers/event_sourcery.rb') }

      it "adds to the rails application name" do
        expect(initializer_file).to contain("module MyApplication")
      end

      it "configures the application" do
        expect(initializer_file).to contain("MyApplication.configure do |config|")
      end

      it "connects with application database_url" do
        expect(initializer_file).to contain("Sequel.connect(MyApplication.config.database_url)")
      end
    end

    context "copy_rake_tasks" do
      let(:rake_tasks_file) { file('lib/tasks/event_sourcery.rake') }

      it "sets up the processors" do
        expect(rake_tasks_file).to contain('processors(MyApplication.projections_database, MyApplication.tracker).each(&:setup)')
      end

      it "resets the processors" do
        expect(rake_tasks_file).to contain('processors(MyApplication.projections_database, MyApplication.tracker).each(&:reset)')
      end

      it "disconnects the database" do
        expect(rake_tasks_file).to contain('MyApplication.projections_database.disconnect')
      end

      it "assigns the processors and event source" do
        expect(rake_tasks_file).to contain('event_processors: processors(MyApplication.projections_database, MyApplication.tracker)')
        expect(rake_tasks_file).to contain('event_source: MyApplication.event_source')
      end
    end
  end
end
