# EventSourcery::Rails
Short description and motivation.

## Usage
How to use my plugin.

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

At this point you will have an initializer to configure EventSourcery and a
rake file with the following tasks.

```
rails event_sourcery:db:migrate # create the event sourcery schema
rails event_sourcery:processors:setup # create projector schemas
rails event_sourcery:processors:reset # drop and recreate projector schemas and data
rails event_sourcery:processors:run # start event stream processors
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
