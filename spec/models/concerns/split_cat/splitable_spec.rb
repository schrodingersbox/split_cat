require 'spec_helper'

describe SplitCat::Splitable do

  let( :experiment ) { FactoryGirl.create( :experiment_full ) }
  let( :splitable ) { experiment.hypotheses.first }

  it 'extends ActiveSupport::Concern' do
    should be_a_kind_of( ActiveSupport::Concern )
  end

  it 'validates the presence of name' do
    expect( splitable.valid? ).to be_true
    splitable.name = nil
    expect( splitable.valid? ).to be_false
  end

  it 'validates the uniqueness of name within the experiment' do
    dupe = splitable.dup
    expect( dupe.valid? ).to be_false
    dupe.experiment_id = nil
    expect( dupe.valid? ).to be_true
  end

  it 'belongs to an experiment' do
    expect( splitable.experiment ).to be( experiment )
  end

end