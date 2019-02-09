require "rails_helper"
require "event_sourcery/rails/generators/install_generator"

module EventSourceryRails
  describe InstallGenerator, type: :generator do
    let(:initializer_file) { file('config/initializers/event_sourcery.rb') }

    it "adds to the rails application name" do
      orig_app = Rails.application

      stub_const('MyApplication::App', Class.new)
      Rails.application = MyApplication::App.new
      generator = run_generator %w(event_sourcery_rails:install)
      expect(initializer_file).to contain("module MyApplication")

      Rails.application = orig_app
    end
  end
end
