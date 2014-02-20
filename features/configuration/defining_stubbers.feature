Feature: Defining stubbers

  You can define your own custom stubbers. See LocalServerStubber for an example.

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

        def port;end
        def host;end
        def scheme;end
        def type;end
      end

      Shokkenki.consumer.configure do
        register_stubber :my_stubber, MyStubber
        define_provider(:my_service).stub_with :my_stubber
      end
      """
    And a consumer spec exists that refers to provider "my_service"
    When I run `rspec`
    Then all examples should pass