require_relative '../../../spec_helper'
require 'shokkenki/consumer/rspec/consumer_name'

describe Shokkenki::Consumer::RSpec::ConsumerName do

  subject { Shokkenki::Consumer::RSpec::ConsumerName }

  context 'extracted from an example group' do
    let(:example) { double(:example, :metadata => metadata)}
    let(:example_group) { double(:example_group, :example => example) }

    context 'when the shokkenki consumer metadata has no value (defaulted to true)' do
      let(:metadata) do
        {
          :shokkenki_consumer => true,
          :example_group => {
            :example_group => {
              :description_args => ['Name', 'some other context']
            }
          }
        }
      end

      it 'is extracted from the first description argument in the last example group' do
        expect(subject.from(example_group)).to eq('Name')
      end
    end

    context 'when the shokkenki consumer metadata has an actual value' do

      let(:metadata) do
        {
          :shokkenki_consumer => 'Name',
          :example_group => {
            :description_args => ['Other Name']
          }
        }
      end

      it 'is that value' do
        expect(subject.from(example_group)).to eq('Name')
      end
    end
  end
end