Feature: During (Labelling Interactions)

  Interactions should be identified by unique labels. This allows them to be referred to more easily in both consumer interaction stubs and provider test failures.

  Use a unique and descriptive label for each interaction that describes the request. Use the opportunity to describe the interaction instead of just the path (we can already tell that by looking at the path its self).

  **Interactions with the same label will overwrite each other**. Only one interaction may have a particular label.

  Scenario: Labelling an interaction
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do

        context 'being greeted' do
          before do
            order(:my_provider).
            during('a greeting').to do
              get('/greeting').and_respond(:status => 200)
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | interactions[0].label | a greeting |