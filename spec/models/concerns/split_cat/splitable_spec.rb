require 'spec_helper'

describe SplitCat::Splitable do

  it 'extends ActiveSupport::Concern' do
    should be_a_kind_of( ActiveSupport::Concern )
  end

end