require 'spec_helper'

module SplitCat
  describe Experiment do

    let( :experiment )         { FactoryGirl.build( :experiment_full ) }
    let( :experiment_created ) { FactoryGirl.create( :experiment_full ) }
    let( :goal )               { FactoryGirl.build( :goal_a ) }
    let( :hypothesis )         { FactoryGirl.build( :hypothesis_a ) }
    let( :config )             { SplitCat::Config.instance }

    let( :experiment_created ) { FactoryGirl.create( :experiment_full ) }
    let( :hypothesis_created ) { experiment_created.hypotheses.first }
    let( :goal_created )       { experiment_created.goals.first }
    let( :subject_created )    { FactoryGirl.create( :subject_a ) }

    def setup_joins
      HypothesisSubject.create(
          :hypothesis_id => hypothesis_created.id,
          :subject_id => subject_created.id,
          :experiment_id => experiment_created.id )
      GoalSubject.create(
          :goal_id => goal_created.id,
          :subject_id => subject_created.id,
          :experiment_id => experiment_created.id,
          :hypothesis_id => hypothesis_created.id  )
    end

    before( :each ) do
      config.experiments.clear
    end

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

      it 'has many goals with an inverse relationship' do
        should have_many( :goals )
        experiment_created.goals.first.experiment.should be( experiment_created )
      end

      it 'has many hypotheses with an inverse relationship' do
        should have_many( :hypotheses )
        experiment_created.hypotheses.first.experiment.should be( experiment_created )
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
          @total_weight = experiment.total_weight
          experiment.stub( :rand ).with( @total_weight ).and_return( 1 )
        end

        it 'generates a random number in range of total hypothesis weight' do
          experiment.choose_hypothesis
        end

        it 'chooses a hypothesis by weight' do
          Kernel.stub( :rand ).and_return( experiment.hypotheses[ 0 ].weight )
          experiment.choose_hypothesis.should eql( experiment.hypotheses[ 1 ] )
        end

        it 'returns the chosen hypothesis' do
          experiment.choose_hypothesis.should be_an_instance_of( Hypothesis )
        end

        it 'returns the first hypothesis if the selection algorithm fails' do
          experiment.hypotheses.should_receive( :each )
          experiment.choose_hypothesis.should eql( experiment.hypotheses.first )
        end
      end

      #############################################################################
      # Experiment#get_hypothesis

      describe '#get_hypothesis' do

        before( :each ) do
          @hypothesis = experiment_created.hypotheses.first
        end

        it 'returns the winner if one is defined' do
          experiment_created.winner = experiment.hypotheses.first
          experiment_created.get_hypothesis( subject_created.token ).should eql( experiment_created.winner )
        end

        it 'returns nil if it can not find the token' do
          token = FactoryGirl.build( :subject_b ).token
          experiment_created.get_hypothesis( token ).should be_nil
        end

        it 'returns the old hypothesis if already assigned' do
          HypothesisSubject.create(
              :hypothesis_id => @hypothesis.id,
              :subject_id => subject_created.id,
              :experiment_id => experiment_created.id )
          experiment_created.get_hypothesis( subject_created.token ).should eql( @hypothesis )
        end

        it 'returns nil if it can not find the old assigned hypothesis' do
          HypothesisSubject.create(
              :hypothesis_id => nil,
              :subject_id => subject_created.id,
              :experiment_id => experiment_created.id )
          experiment_created.get_hypothesis( subject_created.token ).should be_nil
        end

        it 'chooses a hypothesis' do
          experiment_created.should_receive( :choose_hypothesis ).and_return( @hypothesis )
          experiment_created.get_hypothesis( subject_created.token ).should eql( @hypothesis )
        end

        it 'creates a HypothesisSubject record' do
          HypothesisSubject.delete_all
          chosen = experiment_created.get_hypothesis( subject_created.token )
          HypothesisSubject.count.should eql( 1 )

          hs = HypothesisSubject.first
          hs.subject_id.should eql( subject_created.id )
          hs.experiment_id.should eql( experiment_created.id )
          hs.hypothesis_id.should eql( chosen.id )
        end

        it 'returns the chosen hypothesis' do
          experiment_created.should_receive( :choose_hypothesis ).and_return( @hypothesis )
          experiment_created.get_hypothesis( subject_created.token ).should eql( @hypothesis )
        end

      end

      #############################################################################
      # Experiment#goal_counts

      describe '#goal_counts' do

        it 'memoizes the results of GoalSubject.subject_counts' do
          expected = {}
          GoalSubject.should_receive( :subject_counts ).once.with( experiment ).and_return( expected )
          experiment.goal_counts.should eql( expected )
          experiment.goal_counts.should eql( expected )
        end

      end

      #############################################################################
      # Experiment#goal_hash

      describe '#goal_hash' do

        it 'returns a HashWithIndifferentAccess' do
          experiment.goal_hash.should be_an_instance_of( HashWithIndifferentAccess )
        end

        it 'builds a hash of goals' do
          goals = experiment.goal_hash
          goals.size.should > 0
          goals.size.should eql( experiment.goals.size )
          experiment.goals.each { |g| goals[ g.name ].should be_present }
          experiment.goals.each { |g| goals[ g.name.to_sym ].should be_present }
        end

        it 'memoizes the results' do
          experiment.goals.should_receive( :map ).once.and_return( [] )
          experiment.goal_hash
          experiment.goal_hash
        end

      end

      #############################################################################
      # Experiment#hypothesis_counts

      describe '#hypothesis_counts' do

        it 'memoizes the results of HypothesisSubject.subject_counts' do
          expected = {}
          HypothesisSubject.should_receive( :subject_counts ).once.with( experiment ).and_return( expected )
          experiment.hypothesis_counts.should eql( expected )
          experiment.hypothesis_counts.should eql( expected )
        end

      end

      #############################################################################
      # Experiment#hypothesis_hash

      describe '#hypothesis_hash' do

        it 'returns a HashWithIndifferentAccess' do
          experiment.hypothesis_hash.should be_an_instance_of( HashWithIndifferentAccess )
        end

        it 'builds a hash of hypotheses' do
          hypotheses = experiment.hypothesis_hash
          hypotheses.size.should > 0
          hypotheses.size.should eql( experiment.hypotheses.size )
          experiment.hypotheses.each { |h| hypotheses[ h.name ].should be_present }
          experiment.hypotheses.each { |h| hypotheses[ h.name.to_sym ].should be_present }
        end

        it 'memoizes the results' do
          experiment.hypotheses.should_receive( :map ).once.and_return( [] )
          experiment.hypothesis_hash
          experiment.hypothesis_hash
        end
      end

      #############################################################################
      # Experiment#record_goal

      describe '#record_goal' do

        before( :each ) do
          setup_joins
        end

        it 'returns true if a winner has been set on the experiment' do
          experiment_created.winner_id = hypothesis_created.id
          experiment_created.record_goal( goal_created.name, subject_created.token ).should be_true
        end

        it 'returns false if the goal is not found' do
          experiment_created.record_goal( :does_not_exist, subject_created.token ).should be_false
        end

        it 'returns false if the token is not found' do
          experiment_created.record_goal( goal_created.name, :does_not_exist ).should be_false
        end

        it 'returns true if the subject is not assigned to a hypothesis' do
          HypothesisSubject.delete_all
          experiment_created.record_goal( goal_created.name, subject_created.token ).should be_true
        end

        it 'returns true if the goal has already been recorded' do
          experiment_created.record_goal( goal_created.name, subject_created.token ).should be_true
        end

        it 'returns true if it creates a record' do
          GoalSubject.delete_all
          experiment_created.record_goal( goal_created.name, subject_created.token ).should be_true
          GoalSubject.count.should eql( 1 )

          gs = GoalSubject.first
          gs.goal_id.should eql( goal_created.id )
          gs.subject_id.should eql( subject_created.id )
          gs.experiment_id.should eql( experiment_created.id )
          gs.hypothesis_id.should eql( hypothesis_created.id )
        end

      end

      #############################################################################
      # Experiment#same_structure?

      describe '#same_structure?' do

        def same_structure_should_be( bool )
          experiment_created.same_structure?( experiment ).should be( bool ? experiment : nil )
          experiment.same_structure?( experiment_created ).should be( bool ? experiment_created : nil )
        end

        it 'returns true if the experiment, goals, and hypotheses match significantly' do
          same_structure_should_be( true )
        end

        it 'returns false if there is a mismatch in the experiment name' do
          experiment.name = experiment.name.reverse
          same_structure_should_be( false )
        end

        it 'returns false if there is a mismatch in the number of goals' do
          experiment.goals.delete( experiment.goals.first )
          same_structure_should_be( false )
        end

        it 'returns false if there is a mismatch in the name of goals' do
          goal = experiment.goals.first
          goal.name = goal.name.reverse
          same_structure_should_be( false )
        end

        it 'returns false if there is a mismatch in the number of hypotheses' do
          experiment.hypotheses.delete( experiment.hypotheses.first )
          same_structure_should_be( false )
        end

        it 'returns false if there is a mismatch in the name of hypotheses' do
          hypothesis = experiment.hypotheses.first
          hypothesis.name = hypothesis.name.reverse
          same_structure_should_be( false )
        end
      end

      #############################################################################
      # Experiment#total_subjects

      describe '#total_subjects' do

        before( :each ) do
          setup_joins
        end

        it 'returns the sum of hypothesis subjects' do
          expected = experiment_created.hypothesis_counts.values.inject( 0 ) { |sum,count| sum + count }
          expected.should_not eql( 0 )

          experiment_created.total_subjects.should eql( expected )
        end

        it 'memoizes the result' do
          experiment_created.hypothesis_counts.should_receive( :values ).once.and_return( [] )
          experiment_created.total_subjects
          experiment_created.total_subjects
        end

        it 'tolerates nil entries in the count hash' do
          experiment_created.hypothesis_counts[ :foobar ] = nil
          experiment_created.total_subjects
        end

      end

      #############################################################################
      # Experiment#total_weight

      describe '#total_weight' do

        it 'returns the sum of hypothesis weights' do
          expected = experiment_created.hypotheses.inject( 0 ) { |sum,h| sum + h.weight }
          expected.should_not eql( 0 )

          experiment_created.total_weight.should eql( expected )
        end

        it 'memoizes the result' do
          experiment_created.hypotheses.should_receive( :inject ).once.with( 0 ).and_return( 727 )
          experiment_created.total_weight
          experiment_created.total_weight
        end

      end

      #############################################################################
      # Experiment#to_csv

      describe '#to_csv' do

        before( :each ) do
          setup_joins
        end

        it 'generates a CSV of experiment results' do
          experiment_created.to_csv.should eql_file( 'spec/data/models/experiment.csv' )
        end

      end

    end

    #############################################################################
    # ::factory

    describe '::factory' do

      before( :each ) do
        config.experiments.clear
        config.experiment( experiment.name ) do |c|
          experiment.hypotheses.each { |h| c.hypothesis( h.name, h.weight ) }
          experiment.goals.each { |g| c.goal( g.name ) }
        end

        Experiment.cache.clear
      end

      context 'when experiment is not configured' do

        it 'returns nil' do
          Experiment.factory( :does_not_exist ).should be_nil
        end

        it 'returns database version' do
          experiment = Experiment.create( :name => 'foo' )
          Experiment.factory( experiment.name ).should eql( experiment )
        end
      end

      context 'when experiment is configured' do

        describe 'caching' do

          before( :each ) do
            Experiment.should_receive( :includes ).and_return( experiment_created )
            experiment_created.should_receive( :find_by_name ).and_return( experiment_created )
          end

          it 'caches the result' do
            Experiment.factory( experiment_created.name ).should be( experiment_created )
            Experiment.factory( experiment_created.name ).should be( experiment_created )
          end

        end

        context 'and saved' do

          before( :each ) do
            Experiment.should_receive( :includes ).and_return( experiment_created )
            experiment_created.should_receive( :find_by_name ).and_return( experiment_created )
          end

          it 'loads it from the database' do
            Experiment.factory( experiment_created.name ).should be( experiment_created )
          end

          it 'returns the config structure if the db and config do not match' do
            experiment_created.should_receive( :same_structure? ).and_return( false )
            Experiment.factory( experiment_created.name ).should be_nil
          end

          it 'returns the experiment if the structures match' do
            experiment_created.should_receive( :same_structure? ).and_return( true )
            Experiment.factory( experiment_created.name ).should be( experiment_created )
          end

        end

        context 'and not saved' do

          it 'returns the experiment if the save is successful' do
            config.should_receive( :template ).with( experiment.name ).and_return( experiment )
            experiment.should_receive( :save ).and_return( true )
            Experiment.factory( experiment.name ).should be( experiment )
          end

          it 'returns nil if it is unable to save' do
            config.should_receive( :template ).with( experiment.name ).and_return( experiment )
            experiment.should_receive( :save ).and_return( false )
            Experiment.factory( experiment.name ).should be( nil )
          end

        end

      end

    end

  end
end
