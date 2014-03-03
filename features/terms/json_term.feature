Feature: JSON Term

  A JSON term describes part of a JSON message.

  Each first-level key of a JSON term may be a [JSONPath](http://goessner.net/articles/JsonPath/) expression with value is a term describing the value that is required at that path. The JSON supplied may also just be a partial JSON message; the nature of JSONPath is that the term will match and generate examples in either case.

  Examples are generated for JSONPath terms by generating a JSON message that contains an appropriate value at each path location. At the moment only simple expressions are supported, complex path elements such as the following are not supported:

  - numeric elements (x[5])
  - filter elements (x[?(@.attr)])
  - union elements (x[0,1])
  - array slice elements (x[:2])
  - script elements (x[@.length-1)])

  Scenario: JSON term example is a message containing term examples at each path
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
            get('/greeting').and_respond(:body => json('message.greeting' => /hi/, 'message.mood' => 'happy'))
          end
        end

        it 'is greeted with a happy hi' do
          expect(response.body).to eq({:message => {:greeting => 'hi', :mood => 'happy'}}.to_json)
        end

      end
      """
    When I run `rspec`
    Then all examples should pass

  Scenario: JSON term example is a message containing normal examples at each path
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
            get('/greeting').and_respond(:body => json(:message => {:greeting => /hi/, :mood => 'happy'}))
          end
        end

        it 'is greeted with a happy hi' do
          expect(response.body).to eq({:message => {:greeting => 'hi', :mood => 'happy'}}.to_json)
        end

      end
      """
    When I run `rspec`
    Then all examples should pass

  Scenario: JSON term doesn't support complex path elements
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
            get('/greeting').and_respond(:body => json('message[4].greeting' => /hi/))
          end
        end

        it 'is greeted with some response' do
          expect(response.body).to_not be_nil
        end
      end
      """
    When I run `rspec`
    Then the stderr should contain "Numeric element 'message[4]' is not supported"
