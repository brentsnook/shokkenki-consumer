Feature: Defining providers

  Shokkenki needs to know about providers before you refer to them in your examples. This allows it to stub each provider before the testing begins.

  Providers can be stubbed with different stubbers. By default they use the local server stubber which will run a new server on an available port.

  Scenario: Define multiple providers
    Given the following configuration:
      """ruby
      Shokkenki.consumer.configure do
        define_provider :my_service
        define_provider :my_other_service
      end
      """
    And a consumer spec exists that refers to provider "my_service"
    And a consumer spec exists that refers to provider "my_other_service"
    When I run `rspec`
    Then all examples should pass

  Scenario: Specifying a stubber for a provider
    Given the following configuration:
      """ruby
      Shokkenki.consumer.configure do
        define_provider(:my_service) { stub_with :local_server }
      end
      """
    And a consumer spec exists that refers to provider "my_service"
    When I run `rspec`
    Then all examples should pass