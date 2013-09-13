require 'spec_helper'

module SplitCat
  describe Hypothesis do

    let( :experiment ) { FactoryGirl.build( :experiment_full ) }
    let( :association ) { experiment.hypotheses }

    it_behaves_like 'splitable'

  end
end
