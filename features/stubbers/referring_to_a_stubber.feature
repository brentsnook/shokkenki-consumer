Feature: Referring to a Stubber

  Systems under test will need to be configured to talk to each stubber. Stubbers must expose their port, host and scheme for this reason.

  Stubbers are retrieved via their provider.

  Scenario: Determing a stubber host, port and scheme
    Given the following configuration:
      """ruby
      Shokkenki.consumer.configure do
        define_provider(:my_service) do
          stub_with(:local_server, {
            :host => 'localhost',
            :scheme => :http
          })
        end
      end
      """
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Consumer', :shokkenki_consumer do

        let(:stubber) { shokkenki.provider(:my_provider).stubber }

        it 'has access to the numeric stubber port' do
          expect(stubber.port).to match(/\d/)
        end

        it 'has access to the stubber host' do
          expect(stubber.host).to eq('localhost')
        end

        it 'has access to the stubber scheme' do
          expect(stubber.scheme).to eq(:http)
        end

      end
      """
    When I run `rspec`
    Then all examples should pass