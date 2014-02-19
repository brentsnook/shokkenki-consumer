Feature: Specifying ticket location

  Tickets will be written to the specified ticket location. If no ticket location is supplied, tickets will be written to **tickets**.

  Scenario: Tickets are written to the given ticket location
    Given the following configuration:
      """ruby
      Shokkenki.consumer.configure do
        tickets 'custom/ticket/location'
        define_provider :provider
      end
      """
    When I run a shokkenki consumer spec
    Then a file matching %r<custom/ticket/location/.*json> should exist

  Scenario: Tickets are written to **tickets** when no ticket location is specified
   Given the following configuration:
      """ruby
      Shokkenki.consumer.configure do
        define_provider :provider
      end
      """
    When I run a shokkenki consumer spec
    Then a file matching %r<tickets/.*json> should exist
