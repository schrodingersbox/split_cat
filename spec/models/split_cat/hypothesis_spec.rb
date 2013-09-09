require 'spec_helper'

module SplitCat
  describe Hypothesis do

    it_should_behave_like 'an experiment item' do
      let( :factory ) { :hypothesis_a }
    end

  end
end
