require 'spec_helper'

module SplitCat
  describe Experiment do

    let( :experiment_empty ) { FactoryGirl.build( :experiment_empty ) }
    let( :experiment_full ) { FactoryGirl.build( :experiment_full ) }
    let( :goal ) { FactoryGirl.build( :goal_a ) }
    let( :hypothesis ) { FactoryGirl.build( :hypothesis_a ) }

    describe 'database' do

      it 'has columns' do
        should have_db_column( :id ).of_type( :integer )
        should have_db_column( :name ).of_type( :string )
        should have_db_column( :description ).of_type( :string )
        should have_db_column( :winner_id ).of_type( :integer )
        should have_db_column( :created_at ).of_type( :datetime )
      end

      it 'has a  unique index on name' do
        should have_db_index( :name ).unique(true)
      end
    end

    describe 'associations' do

      it 'has many goals' do
        should have_many( :goals )
      end

      it 'has many hypotheses' do
        should have_many( :hypotheses )
      end

      it 'belongs to a winner hypotheses' do
        should belong_to( :winner ).class_name( Hypothesis )
      end

    end

    describe 'constraints' do

      it 'validates the presence of name' do
        should validate_presence_of( :name )
      end

      it 'validates the uniqueness of name' do
        should validate_uniqueness_of( :name )
      end

    end

    context 'instance methods' do

      #############################################################################
      # Experiment#choose_hypothesis

      describe '#choose_hypothesis' do

        before( :each ) do
          @total_weight = experiment_full.total_weight
          experiment_full.should_receive( :rand ).with( @total_weight ).and_return( 1 )
        end

        it 'generates a random number in range of total hypothesis weight' do
          experiment_full.choose_hypothesis
        end

        it 'chooses a hypothesis by weight' do
          experiment_full.choose_hypothesis.should eql( experiment_full.hypotheses.first )
        end

        it 'returns the chosen hypothesis' do
          experiment_full.choose_hypothesis.should be_an_instance_of( Hypothesis )
        end

      end

      #############################################################################
      # Experiment#get_hypothesis

      describe '#get_hypothesis' do

        before( :each ) do
          @experiment = FactoryGirl.create( :experiment_full )
          @subject = FactoryGirl.create( :subject_a )
          @hypothesis = @experiment.hypotheses.first
        end

        it 'returns the winner if one is defined' do
          @experiment.winner = experiment_full.hypotheses.first
          @experiment.get_hypothesis( @subject.token ).should eql( @experiment.winner )
        end

        it 'returns nil if it can not find the token' do
          token = FactoryGirl.build( :subject_b ).token
          @experiment.get_hypothesis( token ).should be_nil
        end

        it 'returns the old hypothesis if already assigned' do
          HypothesisSubject.create( :hypothesis_id => @hypothesis.id, :subject_id => @subject.id, :experiment_id => @experiment.id )
          @experiment.get_hypothesis( @subject.token ).should eql( @hypothesis )
        end

        it 'returns nil if it can not find the old assigned hypothesis' do
          HypothesisSubject.create( :hypothesis_id => nil, :subject_id => @subject.id, :experiment_id => @experiment.id )
          @experiment.get_hypothesis( @subject.token ).should be_nil
        end

        it 'chooses a hypothesis' do
          @experiment.should_receive( :choose_hypothesis ).and_return( @hypothesis )
          @experiment.get_hypothesis( @subject.token ).should eql( @hypothesis )
        end

        it 'creates a HypothesisSubject record' do
          HypothesisSubject.delete_all
          chosen = @experiment.get_hypothesis( @subject.token )
          HypothesisSubject.count.should eql( 1 )

          hs = HypothesisSubject.first
          hs.subject_id.should eql( @subject.id )
          hs.experiment_id.should eql( @experiment.id )
          hs.hypothesis_id.should eql( chosen.id )
        end

        it 'returns the chosen hypothesis' do
          @experiment.should_receive( :choose_hypothesis ).and_return( @hypothesis )
          @experiment.get_hypothesis( @subject.token ).should eql( @hypothesis )
        end

      end

      #############################################################################
      # Experiment#goal_counts

      describe '#goal_counts' do

        it 'memoizes the results of GoalSubject.subject_counts' do
          expected = {}
          GoalSubject.should_receive( :subject_counts ).once.with( experiment_full ).and_return( expected )
          experiment_full.goal_counts.should eql( expected )
          experiment_full.goal_counts.should eql( expected )
        end

      end

      #############################################################################
      # Experiment#goal_hash

      describe '#goal_hash' do

        it 'returns a HashWithIndifferentAccess' do
          experiment_full.goal_hash.should be_an_instance_of( HashWithIndifferentAccess )
        end

        it 'builds a hash of goals' do
          goals = experiment_full.goal_hash
          goals.size.should > 0
          goals.size.should eql( experiment_full.goals.size )
          experiment_full.goals.each { |g| goals[ g.name ].should be_present }
          experiment_full.goals.each { |g| goals[ g.name.to_sym ].should be_present }
        end

        it 'memoizes the results' do
          experiment_full.goals.should_receive( :map ).once.and_return( [] )
          experiment_full.goal_hash
          experiment_full.goal_hash
        end

      end

      #############################################################################
      # Experiment#hypothesis_counts

      describe '#hypothesis_counts' do

        it 'memoizes the results of HypothesisSubject.subject_counts' do
          expected = {}
          HypothesisSubject.should_receive( :subject_counts ).once.with( experiment_full ).and_return( expected )
          experiment_full.hypothesis_counts.should eql( expected )
          experiment_full.hypothesis_counts.should eql( expected )
        end

      end

      #############################################################################
      # Experiment#hypothesis_hash

      describe '#hypothesis_hash' do

        it 'returns a HashWithIndifferentAccess' do
          experiment_full.hypothesis_hash.should be_an_instance_of( HashWithIndifferentAccess )
        end

        it 'builds a hash of hypotheses' do
          hypotheses = experiment_full.hypothesis_hash
          hypotheses.size.should > 0
          hypotheses.size.should eql( experiment_full.hypotheses.size )
          experiment_full.hypotheses.each { |h| hypotheses[ h.name ].should be_present }
          experiment_full.hypotheses.each { |h| hypotheses[ h.name.to_sym ].should be_present }
        end

        it 'memoizes the results' do
          experiment_full.hypotheses.should_receive( :map ).once.and_return( [] )
          experiment_full.hypothesis_hash
          experiment_full.hypothesis_hash
        end
      end

      #############################################################################
      # Experiment#record_goal

      describe '#record_goal' do

        before( :each ) do
          @experiment = FactoryGirl.create( :experiment_full )
          @subject = FactoryGirl.create( :subject_a )

          @goal = @experiment.goals.first
          @hypothesis = @experiment.hypotheses.first
          HypothesisSubject.create( :hypothesis_id => @hypothesis.id, :subject_id => @subject.id, :experiment_id => @experiment.id )
          GoalSubject.create( :goal_id => @goal.id, :subject_id => @subject.id, :experiment_id => @experiment.id, :hypothesis_id => @hypothesis.id  )
        end

        it 'returns true if a winner has been set on the experiment' do
          @experiment.winner_id = @experiment.hypotheses.first.id
          @experiment.record_goal( @goal.name, @subject.token ).should be_true
        end

        it 'returns false if the goal is not found' do
          @experiment.record_goal( :does_not_exist, @subject.token ).should be_false
        end

        it 'returns false if the token is not found' do
          @experiment.record_goal( @goal.name, :does_not_exist ).should be_false
        end

        it 'returns true if the subject is not assigned to a hypothesis' do
          HypothesisSubject.delete_all
          @experiment.record_goal( @goal.name, @subject.token ).should be_true
        end

        it 'returns true if the goal has already been recorded' do
          @experiment.record_goal( @goal.name, @subject.token ).should be_true
        end

        it 'returns true if it creates a record' do
          GoalSubject.delete_all
          @experiment.record_goal( @goal.name, @subject.token ).should be_true
          GoalSubject.count.should eql( 1 )

          gs = GoalSubject.first
          gs.goal_id.should eql( @goal.id )
          gs.subject_id.should eql( @subject.id )
          gs.experiment_id.should eql( @experiment.id )
          gs.hypothesis_id.should eql( @hypothesis.id )
        end

      end

      #############################################################################
      # Experiment#same_structure?

      describe '#same_structure?' do

        let( :experiment ) { FactoryGirl.create( :experiment_full ) }
        let( :test ) { FactoryGirl.build( :experiment_full ) }

        def same_structure_should_be( bool )
          experiment.same_structure?( test ).should be( bool ? test : nil )
          test.same_structure?( experiment ).should be( bool ? experiment : nil )
        end

        it 'returns true if the experiment, goals, and hypotheses match significantly' do
          same_structure_should_be( true )
        end

        it 'returns false if there is a mismatch in the experiment name' do
          test.name = experiment.name.reverse
          same_structure_should_be( false )
        end

        it 'returns false if there is a mismatch in the number of goals' do
          test.goals.delete( test.goals.first )
          same_structure_should_be( false )
        end

        it 'returns false if there is a mismatch in the name of goals' do
          goal = test.goals.first
          goal.name = goal.name.reverse
          same_structure_should_be( false )
        end

        it 'returns false if there is a mismatch in the number of hypotheses' do
          test.hypotheses.delete( test.hypotheses.first )
          same_structure_should_be( false )
        end

        it 'returns false if there is a mismatch in the name of hypotheses' do
          hypothesis = test.hypotheses.first
          hypothesis.name = hypothesis.name.reverse
          same_structure_should_be( false )
        end
      end

      #############################################################################
      # Experiment#total_weight

      describe '#total_weight' do

        let( :experiment ) { FactoryGirl.create( :experiment_full ) }

        it 'returns the sum of hypothesis weights' do
          expected = experiment.hypotheses.inject( 0 ) { |sum,h| sum + h.weight }
          expected.should_not eql( 0 )

          experiment.total_weight.should eql( expected )
        end

        it 'memoizes the result' do
          experiment.hypotheses.should_receive( :inject ).once.with( 0 ).and_return( 727 )
          experiment.total_weight
        end

      end

      #############################################################################
      # Experiment#to_csv

      describe '#to_csv' do

        before( :each ) do
          @experiment = FactoryGirl.create( :experiment_full )
          @subject = FactoryGirl.create( :subject_a )

          @hypothesis = @experiment.hypotheses.first
          @goal = @experiment.goals.first

          HypothesisSubject.create(
            :hypothesis_id => @hypothesis.id,
            :subject_id => @subject.id,
            :experiment_id => @experiment.id
          )

          GoalSubject.create(
            :goal_id => @goal.id,
            :hypothesis_id => @hypothesis.id,
            :subject_id => @subject.id,
            :experiment_id => @experiment.id
          )
        end

        it 'generates a CSV of experiment results' do
          @experiment.to_csv.should eql_file( 'spec/data/models/experiment.csv' )
        end

      end

    end

  end
end
