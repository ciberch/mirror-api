# Mirror::Api

Simple Mirror Api client library

## Installation

Add this line to your application's Gemfile:

    gem 'mirror-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mirror-api

## Usage

``` ruby
api = Mirror::Api::Timeline.new(token)

# Getting all the timeline items
items = api.list

# Insert a simple text item - https://developers.google.com/glass/timeline#inserting_a_simple_timeline_item
item1 = api.create({text: "Hello Word"})

# Inserting an item with reply actions - https://developers.google.com/glass/timeline#user_interaction_with_menu_items
item2 = api.create({text: "Hello Word", menu_items:[{action: "REPLY"}]})

item2 = api.update(item2.id, {text: "Hello Again Word", menu_items:[{action: "REPLY"}]})

api.delete(item2.id)
```

## See Also

Generic Google API Ruby Client

https://github.com/google/google-api-ruby-client

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
