[![Travis-ci](https://travis-ci.org/ciberch/mirror-api.png)](https://travis-ci.org/ciberch/mirror-api)

[![Code Climate](https://codeclimate.com/github/ciberch/mirror-api.png)](https://codeclimate.com/github/ciberch/mirror-api)

# Mirror::Api

Simple Mirror Api client library.

## Benefits

- Robust error handling. You can choose whether to bubble errors or not.
- Snake case(ruby friendly) notation for requests and responses

## Installation

Add this line to your application's Gemfile:

    gem 'mirror-api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mirror-api

## Usage

##Getting Started
###Require the mirror-api gem.
```ruby
require "mirror-api"
```
### Authenticating your client
```ruby
token = Mirror::OAuth.new(client_id, client_secret, refresh_token)

api = Mirror::Api::Client.new(token)
```
##[Timeline](https://developers.google.com/glass/v1/reference/timeline)

### [Listing Timeline items](https://developers.google.com/glass/v1/reference/timeline/list)
```ruby
items = api.timeline.list
```

### [Inserting a Timeline item](https://developers.google.com/glass/v1/reference/timeline/insert)
```ruby
item_1 = api.timeline.insert({text: "What up WORLD?!?!"})
```

### [Inserting a Timeline item with reply actions](https://developers.google.com/glass/timeline#user_interaction_with_menu_items)
```ruby
item_2 = api.timeline.insert({text: "Do you like tacos?", menu_items:[{action: "REPLY"}]})
```

### [Updating a Timeline item](https://developers.google.com/glass/v1/reference/timeline/update)
```ruby
txt = "Seriously, do you like tacos? This is the second time I had to ask you."
item_2 = api.timeline.update(item_2.id, {text: txt, menu_items:[{action: "REPLY"}]})
```

### [Patching a Timeline item](https://developers.google.com/glass/v1/reference/timeline/patch)
```ruby
item_2 = api.timeline.patch(item_2.id, {text: "You realize you are a bad friend right?", menu_items:[{action: "REPLY"}]})
```

### [Getting a Timeline item](https://developers.google.com/glass/v1/reference/timeline/get)
```ruby
api.timeline.get(item_2.id)
```

### [Deleting a Timeline item](https://developers.google.com/glass/v1/reference/timeline/delete)
```ruby
api.timeline.delete(item_2.id)
```

##[Timeline Attachments](https://developers.google.com/glass/v1/reference/timeline/attachments)

### [Listing Timeline Attachments](https://developers.google.com/glass/v1/reference/timeline/attachments/list)
```ruby
attachments = api.timeline.list(item_1.id, {attachments:{}})
```

### [Getting a Timeline Attachment](https://developers.google.com/glass/v1/reference/timeline/attachments/get)
```ruby
#for the sake of getting an id...
attachment = attachments.items.first
api.timeline.get(item_2.id, {attachments:{id: attachment.id}})
```

### [Deleting a Timeline Attachment](https://developers.google.com/glass/v1/reference/timeline/attachments/delete)
```ruby
api.timeline.delete(item_2.id, {attachments:{id: attachment.id}})
```

##[Subscriptions](https://developers.google.com/glass/v1/reference/subscriptions)

### [Listing Subscriptions](https://developers.google.com/glass/v1/reference/subscriptions/list)
```ruby
subscriptions = api.subscriptions.list
```

### [Inserting a Subscription](https://developers.google.com/glass/v1/reference/subscriptions/insert)
```ruby
subscription = api.subscriptions.insert({collection: "timeline", userToken:"user_1", operation: ["UPDATE"], callbackUrl: "https://yourawesomewebsite.com/callback"})
```

### [Updating a Subscription](https://developers.google.com/glass/v1/reference/subscriptions/update)
```ruby
item_2 = api.subscriptions.update(subscription.id, {collection: "timeline", operation: ["UPDATE", "INSERT", "DELETE"], callbackUrl: "https://yourawesomewebsite.com/callback"})

```

### [Deleting a Subscription](https://developers.google.com/glass/v1/reference/subscriptions/delete)
```ruby
api.subscriptions.delete(item_2.id)
```

##[Locations](https://developers.google.com/glass/v1/reference/locations)

### [Listing Locations](https://developers.google.com/glass/v1/reference/locations/list)
```ruby
locations = api.locations.list
```

### [Getting a Location](https://developers.google.com/glass/v1/reference/locations/get)
```ruby
#for the sake of getting an id...
location = locations.items.first
api.locations.get(location.id)
```

##[Contacts](https://developers.google.com/glass/v1/reference/contacts)

### [Listing Contacts](https://developers.google.com/glass/v1/reference/contacts/list)
```ruby
items = api.contacts.list
```

### [Inserting a Contact](https://developers.google.com/glass/v1/reference/contacts/insert)
```ruby
contact = api.contacts.insert({id: '1234', displayName: 'Troll', imageUrls: ["http://pixelr3ap3r.com/wp-content/uploads/2012/08/357c6328ee4b11e1bfbf22000a1c91a7_7.jpg"]})
```

### [Updating a Contact](https://developers.google.com/glass/v1/reference/contacts/update)
```ruby
contact = api.contacts.update(contact.id, {displayName: 'Unicorn'})
```

### [Patching a Contact](https://developers.google.com/glass/v1/reference/contacts/patch)
```ruby
contact = api.contacts.patch(contact.id, {displayName: 'Grumpy Cat', imageUrls: ["http://blog.catmoji.com/wp-content/uploads/2012/09/grumpy-cat.jpeg"]})
```

### [Getting a Contact](https://developers.google.com/glass/v1/reference/contacts/get)
```ruby
api.contacts.get(contact.id)
```

### [Deleting a Contact](https://developers.google.com/glass/v1/reference/contacts/delete)
```ruby
api.contacts.delete(contact.id)
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
