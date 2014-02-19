Feature: Given (Requiring Fixtures)

  A consumer may require that certain fixtures be established before an interaction. A fixture can be used to specify the state that the provider must be in beforehand.

  It is up to the provider to implement each fixture required by its consumers. A consumer is only concerned with specifying the name of the required fixture and any relevant parameters. These parameters can be used to communicate any specific state required (for example a user name that might be used in a consumer test).

  Be careful to avoid leaking the provider's internal details using fixtures: keep them as minimal as possible, using tools such as [Machinist](https://github.com/notahat/machinist) or [Factory Girl](https://github.com/thoughtbot/factory_girl) to fill in the gaps on the provider side.

  Scenario: Requiring a fixture
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do

        context 'being greeted' do
          before do
            order(:my_provider).to do
              given('the provider is in a good mood').
              get('/greeting').and_respond(:status => 200)
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | fixtures[0].name | the provider is in a good mood |

  Scenario: Requiring a fixture with parameters
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do

        context 'being greeted' do
          before do
            order(:my_provider).to do
              given('a provider exists', :name => 'Cecil').
              get('/greeting').and_respond(:status => 200)
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | fixtures[0].arguments.name | Cecil |