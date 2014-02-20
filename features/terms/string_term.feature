Feature: String Term

  A string term defines a simple string value.

  The example generated for a string term is simply its value.

  Scenario: String term uses its value as example
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
      """
    When I run `rspec`
    Then all examples should pass