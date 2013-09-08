require 'spec_helper'

include SplitCat

describe SplitCat do

  it 'requires the engine' do
    SplitCat::Engine.should_not be_nil
  end

  it 'defines the SplitCat module' do
    SplitCat.should_not be_nil
  end

end