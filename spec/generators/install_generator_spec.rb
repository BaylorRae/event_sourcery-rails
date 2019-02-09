require "rails_helper"
require "event_sourcery/rails/generators/install_generator"

module MyApplication
  App = Class.new
end

module EventSourceryRails
  describe InstallGenerator, type: :generator do
    let(:initializer_file) { file('config/initializers/event_sourcery.rb') }

    around do |example|
      orig_app = Rails.application
      Rails.application = MyApplication::App.new
      example.run
      Rails.application = orig_app
    end

    context "copy_initializer" do
      before do
        generator = run_generator %w(event_sourcery_rails:install)
      end

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
  end
end
