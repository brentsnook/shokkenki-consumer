Feature: Local Server Stubber

  The local server stubber mimics a provider by starting a server on the local machine.

  This stubber will find an available port and use it by default. A port can also be supplied as well as a host, scheme and server.

  This is the default stubber used. A different stubber can be configured for each provider if desired.

  Scenario: Using the local server stubber by default
    Given the following configuration:
      """ruby
      Shokkenki.consumer.configure do
        define_provider(:my_service) # use default stubber
      end
      """
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Consumer', :shokkenki_consumer do

        let(:stubber) { shokkenki.provider(:my_provider).stubber }

        it 'uses the local server stubber by default' do
          expect(stubber.type).to eq(:local_server)
        end

      end
      """
    When I run `rspec`
    Then all examples should pass

  Scenario: Customising the local server stubber
    Given the following configuration:
      """ruby
      Shokkenki.consumer.configure do
        define_provider(:my_service).stub_with(:local_server, {
          :host => 'localhost',
          :scheme => :https,
          :port => 1234
        })
      end
      """
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Consumer', :shokkenki_consumer do

        let(:stubber) { shokkenki.provider(:my_provider).stubber }

        it 'uses the given stubber port' do
          expect(stubber.port).to eq(1234)
        end

        it 'uses the given stubber host' do
          expect(stubber.host).to eq('localhost')
        end

        it 'uses the given stubber scheme' do
          expect(stubber.scheme).to eq(:https)
        end

      end
      """
    When I run `rspec`
    Then all examples should pass