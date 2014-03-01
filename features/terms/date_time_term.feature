Feature: Date Time Term

  A date time term represents a datetime containing a year, month and day as well as time in [ISO 8601](http://en.wikipedia.org/wiki/ISO_8601) format.

  The example generated for a date time term is simply its value.

  Scenario: Date time term uses its value as example

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
            get('/greeting').and_respond(:body => json('time' => DateTime.parse('2001-02-03T04:05:06+07:00'))
          end
        end

        it 'is greeted on a specific time in 2001' do
          expect(JSON.parse(response.body)['time']).to eq('2001-02-03T04:05:06+07:00')
        end

      end
      """
    When I run `rspec`
    Then all examples should pass