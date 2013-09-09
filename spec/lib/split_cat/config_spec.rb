require 'spec_helper'

include SplitCat

describe SplitCat::Config do

  let( :config ) { SplitCat::Config.instance }

  it 'is a singleton' do
    config.should be( SplitCat::Config.instance )
  end

  describe '#experiment' do

     it 'does nothing' do
     end
  end

end