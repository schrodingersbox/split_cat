require 'spec_helper'

describe SplitCat::Engine do

  it 'isolates the SplitCat namespace' do
    SplitCat::Engine.isolated.should be_true
  end

end