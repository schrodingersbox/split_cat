require 'spec_helper'

module SplitCat
  describe Goal do

    let( :experiment ) { FactoryGirl.build( :experiment_full ) }
    let( :association ) { experiment.goals }

    it_behaves_like 'splitable'

  end
end
