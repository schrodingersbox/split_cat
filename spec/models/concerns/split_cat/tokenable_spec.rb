require 'spec_helper'

include SplitCat

describe SplitCat::Tokenable do

  let( :tokenable ) { Subject.new }

  it 'extends ActiveSupport::Concern' do
    should be_a_kind_of( ActiveSupport::Concern )
  end

  it 'generates a token before creating' do
    expect( tokenable ).to receive( :generate_token )
    tokenable.save
  end

  it 'generates a token' do
    tokenable.save
    expect( tokenable.token ).to be_present
  end

end