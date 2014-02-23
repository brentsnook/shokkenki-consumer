Shokkenki consumer specs are written in RSpec, see the [RSpec command line documentation](http://relishapp.com/rspec/rspec-core/docs/command-line) for details of how to run them.

Try configuring Shokkenki in your spec helper:

```ruby
require 'shokkenki/consumer/rspec'

Shokkenki.consumer.configure do
  define_provider :my_service
end
```

