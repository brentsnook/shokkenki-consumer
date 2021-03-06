Feature: Given (Requiring Fixtures)

  A consumer may require that certain fixtures be established before an interaction. A fixture can be used to specify the state that the provider must be in beforehand.

  It is up to the provider to implement each fixture required by its consumers. A consumer is only concerned with specifying the name of the required fixture and any relevant parameters. These parameters can be used to communicate any specific state required (for example a user name that might be used in a consumer test).

  Be careful not to leak the provider's internal details too much using fixtures. Keep them as minimal as possible, using tools such as [Machinist](https://github.com/notahat/machinist) or [Factory Girl](https://github.com/thoughtbot/factory_girl) to fill in the gaps on the provider side.

  You may have to pass entity IDs as part of the fixture, expecially if you are referring to them in your paths.

  Scenario: Requiring a fixture
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do

        context 'being greeted' do
          before do
            order(:my_provider).to do
              given('the provider is in a happy mood').
              get('/greeting').and_respond(:status => 200)
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | fixtures[0].name | the provider is in a happy mood |

  Scenario: Requiring a fixture with parameters
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do

        context 'being greeted' do
          before do
            order(:my_provider).to do
              given('a provider exists', :mood => 'happy', :id => 76).
              get('/greeter/76/greeting').and_respond(:status => 200)
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | fixtures[0].arguments.mood | happy |
      | fixtures[0].arguments.id | 76 |