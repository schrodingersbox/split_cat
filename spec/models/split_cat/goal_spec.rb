require 'spec_helper'

module SplitCat
  describe Goal do

    it_should_behave_like 'an experiment item' do
      let( :factory ) { :goal_a }
    end

  end
end
