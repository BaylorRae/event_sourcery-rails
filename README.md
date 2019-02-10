# EventSourcery::Rails
Short description and motivation.

## Usage

### Commands

EventSourcery::Rails adds an optional base class for commands to enforce
instantiating commands with an `aggregate_id` and required parameters as keyword
arguments. Defined attributes are available with an `attr_reader`.

Includes [`ActiveModel::Validations`][active_model_validations] for validating
attributes.

```ruby
class AddUser < EventSourcery::Rails::Command
  attributes :name, :email
  validates_presence_of :name, :email
end

AddUser.new # => raises ArgumentError.new("missing keywords: aggregate_id, name, email")

command = AddUser.new(aggregate_id: 'aggregate-id',
                      name: 'name',
                      email: 'email')
command.aggregate_id # => "aggregate-id"
command.name # => "name"
command.email # => "email"

command.valid? # => true
```

### Command Handlers

You can also optionally include `EventSourcery::Rails::CommandHandler` to use
use a callback DSL for binding commands. This DSL allows your application code
to use all command handlers with `#call`.

**Todo**

- [ ] Consider switching to a base class with common initializer and
    `with_aggregate`
- [ ] Introduce API for invoking all known command handlers with an array of
    commands.

```ruby
class UserCommandHandler
  include EventSourcery::Rails::CommandHandler

  attr_reader :repository

  def initialize(repository: EventSourceryRails.repository)
    @repository = repository
  end

  on AddUser do |command|
    aggregate = repository.load(UserAggregate, aggregate_id)
    aggregate.add(name: command.name,
                  email: command.email)
    repository.save(aggregate)
  end

  on UpdateUserEmail do |command|
    aggregate = repository.load(UserAggregate, aggregate_id)
    aggregate.update_email(email: command.email)
    repository.save(aggregate)
  end
end
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

[active_model_validations]: https://api.rubyonrails.org/classes/ActiveModel/Validations.html#module-ActiveModel::Validations-label-Active+Model+Validations
