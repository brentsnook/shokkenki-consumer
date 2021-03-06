Shokkenki Consumer allows consumers to specify [consumer driven contracts using Shokkenki](https://github.com/brentsnook/shokkenki).

Consumer tests can express a contract as a series of HTTP interactions that can be used to stub out the provider in those tests. Those interactions can then be saved as a Shokkenki ticket and then used by [Shokkenki Provider](https://github.com/brentsnook/shokkenki-provider) tests to ensure that a provider honours that contract.

## Install

    gem install shokkenki-consumer

## Consumer RSpec

```ruby
require 'shokkenki/consumer/rspec'
require_relative 'hungry_man'

Shokkenki.consumer.configure do
  define_provider :restaurant
end

describe HungryMan, :shokkenki_consumer do

  context 'when his ramen is hot' do

    before do
      order(:my_provider).during('order for ramen').to do
        get('/order/ramen').and_respond(:body => json('flavour' => /tasty/))
      end
    end

    it 'is happy' do
      expect(subject.happy?).to be_true
    end
  end
end
```

This example will stub the provider, allowing consumer specs to run. A ticket that serialises these interactions will be written to the default ticket location.

## Need help?

Try the [Shokkenki Google Group](http://groups.google.com/forum/#!forum/shokkenki) (you must be a member to post).

## Bugs or Feature Requests for the Project/Documentation?

Please use [Shokkenki Consumer Issues on Github](http://github.com/brentsnook/shokkenki-consumer/issues). Have your say on the features that you want.

## Code

[Shokkenki consumer on Github](https://github.com/brentsnook/shokkenki-consumer).