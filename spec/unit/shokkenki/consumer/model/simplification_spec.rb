require_relative '../../../spec_helper'
require 'shokkenki/consumer/model/simplification'

describe Shokkenki::Consumer::Model::Simplification do
  include Shokkenki::Consumer::Model::Simplification

  context 'when there is no name' do
    it 'does nothing' do
      expect(simplify(nil)).to be_nil
    end
  end

  it 'removes modules from classes' do
    module MyModule;class Thing;end;end
    expect(simplify(MyModule::Thing)).to eq(:thing)
  end

  it 'removes all non-word characters' do
    expect(simplify(%q{!clee@#$%^&*()-+=~`;:'"\\?/><.,][\{\}]tus})).to eq(:cleetus)
  end

  it 'replaces spaces with underscores' do
    expect(simplify(:"billy bob")).to eq(:billy_bob)
  end

  it 'removes leading and trailing white space' do
    expect(simplify(:"\t pete  ")).to eq(:pete)
  end

end