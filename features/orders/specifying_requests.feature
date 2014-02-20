Feature: Receive (Specifying Requests)

  Each interaction begins with a request. A request must have a path which is a String and a method (such as GET) which is a symbol. Shokkenki also allows the request to be specified via the HTTP method verb for terseness.

  A request may also have an optional query, body and headers. Each of these additional parts of the request may be a Shokkenki term.

  Scenario: Specify a request with `receive`
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do

        context 'being greeted' do
          before do
            order(:my_provider).to do
              receive(:path => '/greeting', :method => :get).
              and_respond(:status => 200)
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | request.path.value | /greeting |
      | request.method.value | get |

  Scenario: Specify a request using HTTP verbs
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do

        context 'being greeted' do
          before do
            order(:my_provider).to do
              get('/greeting/get').
              and_respond(:status => 200)
            end
            order(:my_provider).to do
              post('/greeting/post').
              and_respond(:status => 200)
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | request.path.value | /greeting/get |
      | request.method.value | get |
      | request.path.value | /greeting/post |
      | request.method.value | post |

  Scenario: Specify a request query
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do

        context 'being greeted' do
          before do
            order(:my_provider).to do
              get(
                '/greeting',
                :query => 'weather=nice'
              ).and_respond(:status => 200)
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | request.query.value | weather=nice |

  Scenario: Specify a request body
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do

        context 'being greeted' do
          before do
            order(:my_provider).to do
              get(
                '/greeting',
                :body => 'full'
              ).and_respond(:status => 200)
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | request.body.value | full |

  Scenario: Specify request headers
    Given a configuration exists that defines the provider "my_provider"
    And a file named "spec/spec.rb" with:
      """ruby
      describe 'Greeting Consumer', :shokkenki_consumer do

        context 'being greeted' do
          before do
            order(:my_provider).to do
              get(
                '/greeting',
                :headers => {
                  :accept => 'application/json'
                }
              ).and_respond(:status => 200)
            end
          end

          it 'is greeted' {}
        end
      end
      """
    When I run `rspec`
    Then a ticket should exist with:
      | request.headers.accept | application/json |