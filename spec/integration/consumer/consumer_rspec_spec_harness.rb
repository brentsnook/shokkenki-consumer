require_relative '../harness_helper'
require 'shokkenki/consumer/rspec'
require 'httparty'
require 'json'

Shokkenki.consumer.configure do
  tickets ENV['ticket_directory']
  define_provider :my_provider
end

describe 'My Consumer', :shokkenki_consumer do

  context 'when a simple request is stubbed' do
    before do
      order(:my_provider).during('a greeting').to do
        given(:weather, :temperature => 30).
        get('/greeting').
        and_respond(
          :status => 200,
          :body => json('$.chatter.inane' => /hello there, its a warm one today /)
        )
      end
    end

    it 'receives the stubbed response' do
      stubber = shokkenki.provider(:my_provider).stubber
      url = "http://#{stubber.host}:#{stubber.port}/greeting"
      body = HTTParty.get(url).body
      expect(JSON.parse(body)['chatter']['inane']).to match(/hello there, its a warm one today/)
    end
  end
end