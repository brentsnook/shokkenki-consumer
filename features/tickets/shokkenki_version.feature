Feature: Ticket Shokkenki version

  The Shokkenki consumer version is included in the ticket.

  This allows the provider tests to determine whether they will be able to interpret tickets produced by a particular consumer.

  Scenario: Ticket includes Shokkenki consumer version
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
      "version": "0.4.0"
    }
    """