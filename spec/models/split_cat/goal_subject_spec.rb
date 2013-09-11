require 'spec_helper'

module SplitCat
  describe GoalSubject do

    describe 'database' do

      it 'has columns' do
        should have_db_column( :id ).of_type( :integer )
        should have_db_column( :goal_id ).of_type( :integer )
        should have_db_column( :subject_id ).of_type( :integer )
        should have_db_column( :experiment_id ).of_type( :integer )
        should have_db_column( :hypothesis_id ).of_type( :integer )
        should have_db_column( :created_at ).of_type( :datetime )
      end

      it 'has indexes' do
        should have_db_index( [ :goal_id, :subject_id ] ).unique( true )
        should have_db_index( :experiment_id )
      end

    end

    describe '#subject_counts' do

      it 'returns a hash of hypothesis name => count' do
        experiment = FactoryGirl.create( :experiment_full )
        subject = FactoryGirl.create( :subject_a )
        hypothesis = experiment.hypotheses.first
        goal = experiment.goals.first

        GoalSubject.create(
            :goal_id => goal.id,
            :hypothesis_id => hypothesis.id,
            :subject_id => subject.id,
            :experiment_id => experiment.id )

        counts = GoalSubject.subject_counts( experiment )
        counts.should be_an_instance_of( Hash )
        counts[ goal.name.to_sym ][ hypothesis.name.to_sym ].should eql( 1 )
      end

    end

  end
end
