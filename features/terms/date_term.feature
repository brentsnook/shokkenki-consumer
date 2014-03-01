Feature: Date Term

  A date term represents a date containing a year, month and day in [ISO 8601](http://en.wikipedia.org/wiki/ISO_8601) format.

  The example generated for a date term is simply its value.

  Scenario: Date term uses its value as example

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
            get('/greeting').and_respond(:body => json('date' => Date.parse('2014-02-03'))
          end
        end

        it 'is greeted on the 3rd of Feb 2014' do
          expect(JSON.parse(response.body)['date']).to eq('2014-02-03')
        end

      end
      """
    When I run `rspec`
    Then all examples should pass