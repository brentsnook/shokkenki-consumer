Feature: Defining stubbers

  Stubbers are used to stub out a provider during a consumer test.

  Stubbers must allow interactions to be stubbed and cleared. They are also notified of when the Shokkenki session starts and closes to enable them to perform any setup or cleanup required.

  Stubbers can also be queried for unmatched requests (requests that were received by the stubber that did not match any interactions) or unused interactions (interactions that were stubbed but never matched any requests).

  You can define your own custom stubbers. See HttpStubber for an example.

  Scenario: Define and use a custom stubber
    Given the following configuration:
      """ruby
      class MyStubber
        def stub_interaction interaction;end
        def clear_interaction_stubs;end
        def session_started;end
        def session_closed;end
        def unmatched_requests;end
        def unused_interactions;end
      end

      Shokkenki.consumer.configure do
        register_stubber :my_stubber, MyStubber
        define_provider(:my_service).stub_with :my_stubber
      end
      """
    And a consumer spec exists that refers to provider "my_service"
    When I run `rspec`
    Then the stderr should not contain anything