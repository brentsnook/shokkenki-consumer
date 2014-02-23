Feature: Interacting with the stubber

  The stubber for each provider allows you to list:

  - unused interactions - interactions that the stubber did not match any request to
  - unmatched requests - requests the provider stub saw but didn't have an interaction for

  Scenario: List unused interactions
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Consumer', :shokkenki_consumer do

        context 'being greeted' do
          let(:stubber) { shokkenki.provider(:my_provider).stubber }

          before do
            order(:my_provider).to do
              during('a greeting').
              get('/greeting').
              and_respond(:status => 200)
            end
          end

          it 'is greeted' do
            puts stubber.unused_interactions
          end
        end

      end
      """
    When I run `rspec`
    Then the output should contain:
      """
      {"label"=>"a greeting"}
      """

  Scenario: List unmatched requests
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      require 'httparty'
      describe 'Consumer', :shokkenki_consumer do

        context 'being greeted' do
          let(:stubber) { shokkenki.provider(:my_provider).stubber }

          it 'is greeted' do
            HTTParty.get "http://#{stubber.host}:#{stubber.port}/greeting"
            puts stubber.unmatched_requests
          end
        end

      end
      """
    When I run `rspec`
    Then the output should contain:
      """
      {"path"=>"/greeting", "method"=>"get"
      """