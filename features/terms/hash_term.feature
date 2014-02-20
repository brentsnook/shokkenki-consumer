Feature: Hash Term

  A hash term contains a number of keys and values. Each value is also be a term, making the hash term composable.

  Examples are generated for hash terms by generating an example for each term value.

  The parameters passed to requests and responses are interpreted as hash terms.

  Scenario: Hash term generates an example for each key

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
            get('/greeting').and_respond(:body => 'hi', :status => 404)
          end
        end

        it 'is greeted with a successful hi' do
          expect(response.body).to eq('hi')
          expect(response.status).to eq(404)
        end

      end
      """
    When I run `rspec`
    Then all examples should pass