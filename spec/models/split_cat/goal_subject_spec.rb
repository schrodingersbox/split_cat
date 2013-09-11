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

    #############################################################################
    # GoalSubject::subject_counts

    describe '::subject_counts' do

      let( :experiment ) { FactoryGirl.create( :experiment_full ) }
      let( :subject )    { FactoryGirl.create( :subject_a ) }

      it 'returns a hash of hypothesis name => count' do
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

      it 'includes goals with no subjects in db' do
        goal = experiment.goals.first
        counts = GoalSubject.subject_counts( experiment )

        counts.size.should eql( experiment.goals.size )
        experiment.goals.each do |goal|
          counts[ goal.name.to_sym ].should eql( {} )
        end

      end

    end

    #############################################################################
    # GoalSubject::subject_count_sql

    describe '::subject_count_sql' do

      let( :experiment ) { FactoryGirl.create( :experiment_full ) }

      it 'generates SQL given an experiment' do
        GoalSubject.send( :subject_count_sql, experiment ).should eql_file( 'spec/data/goal_subject_count_sql.sql' )
      end
    end

  end
end
