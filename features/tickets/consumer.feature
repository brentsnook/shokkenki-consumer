Feature: Ticket Consumer

  The label and name are for the consumer are included in the ticket.

  Scenario: Ticket includes consumer name and label
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Consumer', :shokkenki_consumer do

        it 'is greeted' {}

      end
      """
    When I run `rspec`
    Then a ticket should be produced including:
    """JSON
    {
      "consumer": {
        "name": "my_consumer",
        "label": "My Consumer"
      }
    }
    """