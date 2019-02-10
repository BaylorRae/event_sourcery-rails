# EventSourcery::Rails
Short description and motivation.

## Usage

### Commands

EventSourcery::Rails adds an optional base class for commands to enforce
instantiating commands with an `aggregate_id` and required parameters as keyword
arguments. Defined attributes are available with an `attr_reader`.

```ruby
class AddUser < EventSourcery::Rails::Command
  attributes :name, :email
end

AddUser.new # => raises ArgumentError.new("missing keywords: aggregate_id, name, email")

command = AddUser.new(aggregate_id: 'aggregate-id',
                      name: 'name',
                      email: 'email')
command.aggregate_id # => "aggregate-id"
command.name # => "name"
command.email # => "email"
```

## Installation
Add the following line to your Gemfile.

```ruby
gem 'event_sourcery'
gem 'event_sourcery-postgres'
gem 'event_sourcery-rails'
```

Then run `bundle install`

Next, your need to run the generator:

```bash
$ rails generate event_sourcery_rails:install
```

At this point you will have an initializer to configure EventSourcery and the
following Rake tasks.

```bash
$ rails event_sourcery:db:migrate # create the event sourcery schema
$ rails event_sourcery:processors:setup # create projector schemas
$ rails event_sourcery:processors:reset # drop and recreate projector schemas and data
$ rails event_sourcery:processors:run # start event stream processors
```

Typically you'll have the following in your Procfile.

```yaml
web: rails server
processors: rails event_sourcery:processors:run
```

## Contributing
Please submit issues and pull requests for bugs, features or ideas.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
