Feature: And Respond (Specifying Responses)

  Each request must have a matching response. Responses are used to generate actual HTTP responses when stubbing a provider. They are also used by provider tests to ensure that a provider response matches what is expected by a consumer.

  A response may have a status, body or headers. Each of these parts of the response may be a Shokkenki term.

  Scenario: Specify a response status
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do

        context 'being greeted' do
          before do
            order(:my_provider).to do
              get('/greeting').
              and_respond(:status => 200)
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | response.status.value | 200 |

  Scenario: Specify a response body
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do

        context 'being greeted' do
          before do
            order(:my_provider).to do
              get('/greeting').
              and_respond(:body => 'howdy')
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | response.body.value | howdy |

  Scenario: Specify response headers
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do

        context 'being greeted' do
          before do
            order(:my_provider).to do
              get('/greeting').
              and_respond(:headers => {
                :pragma => 'no-cache'
              })
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | response.headers.pragma.value | no-cache |
