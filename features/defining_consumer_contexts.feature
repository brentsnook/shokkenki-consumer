Feature: Defining consumer contexts

  Consumer RSpec contexts need to be identified to Shokkenki by including `:shokkenki_consumer` in their metadata. This allows Shokkenki to weave its magic at the appropriate times as the specs are run.

  Defining a context as a `:shokkenki_consumer` will cause Shokkenki to use the context name as the consumer label. You can also specify a custom consumer label in the metadata.

  Scenario: Context name is used as the consumer name and label
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do
        it 'is greeted' {}
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | consumer.label | Greeting Consumer |

  Scenario: Consumer label is specified
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer => 'My Consumer' do
        it 'is greeted' {}
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | consumer.label | My Consumer |