Feature: Ticket name

  Tickets are named to reflect the consumer and provider that the contract involves.

  Scenario: Ticket name includes consumer and provider name
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'My Consumer', :shokkenki_consumer do

        it 'is greeted' {}

      end
      """
    When I run `rspec`
    Then a ticket exists named "my_consumer-my_provider.json"