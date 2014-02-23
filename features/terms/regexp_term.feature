Feature: Regular Expression Term

  A regular expression term contains simple pattern value expressed in Ruby regular expression format.

  Regular expression terms have their examples generated using [Ruby String Random](http://github.com/repeatedly/ruby-string-random).

  Scenario: Number term example matches its pattern

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
            get('/greeting').and_respond(:body => /hi/)
          end
        end

        it 'is greeted with a hi of some sort' do
          expect(response.body).to match(/hi/)
        end

      end
      """
    When I run `rspec`
    Then all examples should pass