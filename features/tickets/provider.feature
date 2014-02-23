Feature: Ticket Provider

  The label and name are for the provider are included in the ticket.

  Scenario: Ticket includes provider name and label
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
      "provider": {
        "name": "my_provider",
        "label": "My Provider"
      }
    }
    """