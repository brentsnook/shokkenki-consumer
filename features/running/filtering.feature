Feature: Filtering Shokkenki Consumer Examples

  You can run just the Shokkenki consumer examples in your test suite by using the [RSpec command line tag option](https://relishapp.com/rspec/rspec-core/docs/command-line/tag-option).

  Scenario: Run only Shokkenki consumer examples using the --tag option
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Consumer', :shokkenki_consumer do

        let(:response) do
          stubber = shokkenki.provider(:my_provider).stubber
          url = "http://#{stubber.host}:#{stubber.port}/greeting"
          HTTParty.get url
        end

        before do
          order(:my_provider).to do
            get('/greeting').and_respond(:body => 'howdy')
          end
        end

        it 'is greeted with howdy' do
          expect(response.body).to eq('howdy')
        end

      end

      describe 'Some other thing' do
        it 'does unrelated stuff' {}
      end

      """
    When I run `rspec . --format documentation --tag shokkenki_consumer`
    Then all specs should pass
    And the output should contain:
      """
      is greeted with howdy
      """
    But the output should not contain
      """
      does unrelated stuff
      """