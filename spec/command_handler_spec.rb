require "rails_helper"

module EventSourcery
  module Rails
    describe CommandHandler do
      before do
        stub_const('CreateUser', Class.new(Command))
        CreateUser.class_eval do
          attributes :username
        end
      end

      it "subscribes to a command" do
        callback = spy('callback')

        stub_const('UserCommandHandler', Class.new)
        UserCommandHandler.class_eval do
          include CommandHandler

          on CreateUser do |command|
            callback.call(command.username)
          end
        end

        aggregate_id = double(:aggregate_id)
        username = double(:username)
        command = CreateUser.new(aggregate_id: aggregate_id, username: username)
        UserCommandHandler.new.call(command)

        expect(callback).to have_received(:call).with(username)
      end

      it "provides access to the instance" do
        callback = spy('callback')

        stub_const('UserCommandHandler', Class.new)
        UserCommandHandler.class_eval do
          include CommandHandler

          def initialize(callback)
            @callback = callback
          end

          on CreateUser do |command|
            private_helper(command.username)
          end

          private

          def private_helper(username)
            @callback.call(username)
          end
        end

        aggregate_id = double(:aggregate_id)
        username = double(:username)
        command = CreateUser.new(aggregate_id: aggregate_id, username: username)
        UserCommandHandler.new(callback).call(command)

        expect(callback).to have_received(:call).with(username)
      end

      it "doesn't call the wrong binding" do
        create_callback = spy(:create_callback)
        change_username_callback = spy(:change_username_callback)

        stub_const('ChangeUsername', Class.new(Command))
        ChangeUsername.class_eval do
          attributes :username
        end

        stub_const('UserCommandHandler', Class.new)
        UserCommandHandler.class_eval do
          include CommandHandler

          on CreateUser do |command|
            create_callback.call(command.username)
          end

          on ChangeUsername do |command|
            change_username_callback.call(command.username)
          end
        end

        aggregate_id = double(:aggregate_id)
        username = double(:username)
        command = ChangeUsername.new(aggregate_id: aggregate_id, username: username)
        UserCommandHandler.new.call(command)

        expect(create_callback).to_not have_received(:call)
        expect(change_username_callback).to have_received(:call).with(username).once
      end

      it "doesn't share commands" do
        callback = spy('callback')

        stub_const('UserCommandHandler', Class.new)
        UserCommandHandler.class_eval do
          include CommandHandler

          on CreateUser do |command|
            callback.call(command.username)
          end
        end

        stub_const('PostCommandHandler', Class.new)
        PostCommandHandler.class_eval do
          include CommandHandler

          on Command do |command|
            callback.call('invalid')
          end
        end

        aggregate_id = double(:aggregate_id)
        username = double(:username)
        command = CreateUser.new(aggregate_id: aggregate_id, username: username)
        UserCommandHandler.new.call(command)
        PostCommandHandler.new.call(command)

        expect(callback).to have_received(:call).once
        expect(UserCommandHandler.command_events.keys).to eq([CreateUser])
        expect(PostCommandHandler.command_events.keys).to eq([Command])
      end
    end
  end
end
