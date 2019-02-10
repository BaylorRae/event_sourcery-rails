# EventSourcery::Rails
[![Build Status](https://travis-ci.org/BaylorRae/event_sourcery-rails.svg?branch=master)](https://travis-ci.org/BaylorRae/event_sourcery-rails)

I wanted to add [Event Sourcing][event_sourcing_fowler] to my Rails application
and after using several libraries/framework settled on EventSourcery from
Envato. After creating a demo application based on their todo example with Rails
I realized the installation steps are pretty simple. With this gem it can be
installed and configured with a single rake task!

In addition to automating the install, I also wanted to incorporate the DSL from
Sequent and RailsEventStore for commands and command handlers. I like the
command handler itself wrapping single responsibility around an aggregate with
the `on` command binding. I also wanted to remove the boilerplate for
instantiating and validating commands since we can load
`ActiveModel::Validations` for free.

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

[event_sourcing_fowler]: https://martinfowler.com/eaaDev/EventSourcing.html
[active_model_validations]: https://api.rubyonrails.org/classes/ActiveModel/Validations.html#module-ActiveModel::Validations-label-Active+Model+Validations
