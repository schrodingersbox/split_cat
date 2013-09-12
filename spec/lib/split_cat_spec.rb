require 'spec_helper'

include SplitCat

describe SplitCat do

  it 'requires the engine' do
    SplitCat::Engine.should_not be_nil
  end

  it 'defines the SplitCat module' do
    SplitCat.should_not be_nil
  end

  #############################################################################
  # SplitCat::config

  describe '::config' do

    it 'returns the configuration' do
      SplitCat.config.should be_an_instance_of( SplitCat::Config )
    end

  end

  #############################################################################
  # SplitCat::configure

  describe '::configure' do

    it 'yields the configuration' do
      SplitCat.configure { |config| config.should be_an_instance_of( SplitCat::Config ) }
    end

  end

end