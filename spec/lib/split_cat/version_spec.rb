require 'spec_helper'

describe 'version' do

  it 'has a version constant' do
    SplitCat::VERSION.should_not be_nil
    SplitCat::VERSION.should be_an_instance_of( String )
    SplitCat::VERSION.should =~ /\d+\.\d+\.\d+/
  end

end