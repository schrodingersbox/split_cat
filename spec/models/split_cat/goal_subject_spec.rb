require 'spec_helper'

module SplitCat
  describe GoalSubject do

    let( :experiment ) { FactoryGirl.create( :experiment_full ) }

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

      before( :each ) do
        @hypothesis = experiment.hypotheses.first
        @goal = experiment.goals.first
        @subject = FactoryGirl.create( :subject_a )

        GoalSubject.create(
            :goal_id => @goal.id,
            :hypothesis_id => @hypothesis.id,
            :subject_id => @subject.id,
            :experiment_id => experiment.id )

      end

      it 'returns a HashWithIndifferentAccess' do
        counts =  GoalSubject.subject_counts( experiment )
        counts.should be_an_instance_of( HashWithIndifferentAccess )
        counts[ @goal.name ].should be_an_instance_of( HashWithIndifferentAccess )
      end

      it 'returns a hash of hypothesis name => count' do
        counts = GoalSubject.subject_counts( experiment )
        counts[ @goal.name ][ @hypothesis.name ].should eql( 1 )
      end

      it 'includes goals with no subjects in db' do
        GoalSubject.delete_all
        counts = GoalSubject.subject_counts( experiment )

        counts.size.should eql( experiment.goals.size )
        experiment.goals.each do |goal|
          counts[ goal.name ].should eql( {} )
        end
      end

      it 'returns an empty hash if the query fails' do
        ActiveRecord::Base.connection.should_receive( :execute ).and_return( [] )
        GoalSubject.subject_counts( experiment )[ @goal.name ].should be_empty
      end

    end

    #############################################################################
    # GoalSubject::subject_count_sql

    describe '::subject_count_sql' do

      it 'generates SQL given an experiment' do
        sql = GoalSubject.send( :subject_count_sql, experiment )
        sql.should eql_file( 'spec/data/models/goal_subject_count_sql.sql' )
      end
    end

    #############################################################################
    # GoalSubject::subject_count_row

    describe '::subject_count_row' do

      before( :each ) do
        @counts = HashWithIndifferentAccess.new
        @hypothesis = experiment.hypotheses.first
        @goal = experiment.goals.first
        @subject_count = 5
      end

      it 'parses sql hash results into the counts hash' do
        row = {
            'goal_id' => @goal.id,
            'hypothesis_id' => @hypothesis.id.to_s,
            'subject_count' => @subject_count.to_s
        }

        GoalSubject.subject_count_row( @counts,  row )
        @counts[ @goal.id ].should eql( { @hypothesis.id => @subject_count } )
      end

      it 'parses sql array results into the counts hash' do
        row = [ @goal.id, @hypothesis.id.to_s, @subject_count.to_s ]
        GoalSubject.subject_count_row( @counts,  row )

        @counts[ @goal.id ].should eql( { @hypothesis.id => @subject_count } )
      end

    end

  end
end
