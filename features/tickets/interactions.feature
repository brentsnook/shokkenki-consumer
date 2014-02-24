Feature: Ticket Interactions

  The details of each interaction are included in the ticket.

  These details include the label, the fixtures required by the interaction, the request, the response and the time that the interaction was created.

  Scenario: Ticket includes interaction label, fixtures, and time
    Given a configuration exists that defines the provider "my_provider"
    And the time is 7am on 18th of December 2013
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Consumer', :shokkenki_consumer do
        context 'being greeted' do
          before do
            order(:my_provider).to do
              during('a greeting').
              given('a provider exists', :name => 'Cecil').
              get('/greeting').and_respond(:status => 200)
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should be produced including:
    """JSON
    {
      "interactions": [
        {
          "time": "2013-12-18T07:00:00Z",
          "label": "a greeting",
          "fixtures": [
            {
              "name": "a provider exists",
              "arguments": {
                "name": "Cecil"
              }
            }
          ]
        }
      ]
    }
    """

  Scenario: Ticket includes interaction request
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Consumer', :shokkenki_consumer do
        context 'being greeted' do
          before do
            order(:my_provider).to do
              get('/greeting', :headers => {:accept => /json/}).
              and_respond(:status => 200)
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should be produced including:
    """JSON
    {
      "interactions": [
        {
          "request": {
            "type": "hash",
            "value": {
              "path": {
                "type": "string",
                "value": "/greeting"
              },
              "method": {
                "type": "string",
                "value": "get"
              },
              "headers": {
                "type": "hash",
                value: {
                  "accept" => {
                    "type": "regexp",
                    "value": "/json/"
                  }
                }
              }
            }
          }
        }
      ]
    }
    """

  Scenario: Ticket includes interaction response
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Consumer', :shokkenki_consumer do
        context 'being greeted' do
          before do
            order(:my_provider).to do
              get('/greeting').
              and_respond(
                :status => 200,
                :body => json(
                  'message.greeting' => /howdy/
                )
              )
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should be produced including:
    """JSON
    {
      "interactions": [
        {
          "response": {
            "type": "hash",
            "value": {
              "status": {
                "type": "number",
                "value": 200
              },
              "body": {
                "type": "json_paths",
                value: {
                  "message.greeting" => {
                    "type": "regexp",
                    "value": "/howdy/"
                  }
                }
              }
            }
          }
        }
      ]
    }
    """