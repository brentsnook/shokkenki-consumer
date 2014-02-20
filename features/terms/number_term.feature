Feature: Number Term

  A number term defines a simple numeric value.

  The example generated for a number term is simply its value.

  Scenario: Number term uses its value as example
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
            get('/greeting').and_respond(:status => 404)
          end
        end

        it 'is greeted with a 404' do
          expect(response.body).to eq(404)
        end

      end
      """
    When I run `rspec`
    Then all examples should pass