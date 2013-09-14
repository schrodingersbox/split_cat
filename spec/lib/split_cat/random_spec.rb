require 'spec_helper'

include SplitCat

module SplitCat
  module Random

    describe '::generate' do

      before( :each ) do
        @n_subjects = 10
        @n_experiments = 2
        @max_items = 5

        @args = { :n_subjects => @n_subjects, :n_experiments => @n_experiments, :max_items => @max_items }
      end

      it 'generates the requested data' do
        Subject.count.should eql( 0 )
        Experiment.count.should eql( 0 )
        Hypothesis.count.should eql( 0 )
        Goal.count.should eql( 0 )
        HypothesisSubject.count.should eql( 0 )
        GoalSubject.count.should eql( 0 )

        SplitCat::Random.generate( @args )

        Subject.count.should eql( @n_subjects )
        Experiment.count.should eql( @n_experiments )
        Hypothesis.count.should > 0
        Goal.count.should > 0
        HypothesisSubject.count.should > 0
        GoalSubject.count.should > 0
      end

    end

  end
end