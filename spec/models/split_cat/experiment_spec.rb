require 'spec_helper'

module SplitCat
  describe Experiment do

    describe 'associations' do

      it 'has many goals' do
        should have_many( :goals )
      end

      it 'has many hypotheses' do
        should have_many( :hypotheses )
      end

    end

    describe 'database' do

      it 'has columns' do
        should have_db_column( :id ).of_type( :integer )
        should have_db_column( :name ).of_type( :string )
        should have_db_column( :description ).of_type( :string )
        should have_db_column( :created_at ).of_type( :datetime )
      end

      it 'has a  unique index on name' do
        should have_db_index( :name ).unique(true)
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

      let( :experiment ) { FactoryGirl.build( :experiment_empty ) }
      let( :goal ) { FactoryGirl.build( :goal_a ) }
      let( :hypothesis ) { FactoryGirl.build( :hypothesis_a ) }

      describe '#add_goal' do

        it 'adds a goal to the experiment' do
          goals = experiment.goals
          goals.should be_empty
          experiment.add_goal( goal.name, goal.description )

          goals.size.should eql( 1 )
          goals.first.name.should eql( goal.name )
          goals.first.description.should eql( goal.description )
        end

      end

      describe '#add_hypothesis' do

        it 'adds a hypothesis to the experiment' do
          hypotheses = experiment.hypotheses
          hypotheses.should be_empty
          experiment.add_hypothesis( hypothesis.name, hypothesis.weight, hypothesis.description )

          hypotheses.size.should eql( 1 )
          hypotheses.first.name.should eql( hypothesis.name )
          hypotheses.first.weight.should eql( hypothesis.weight )
          hypotheses.first.description.should eql( hypothesis.description )
        end

      end

      describe '#same_structure?' do

        let( :experiment ) { FactoryGirl.create( :experiment_full ) }
        let( :test ) { FactoryGirl.build( :experiment_full ) }

        def same_structure_should_be( bool )
          experiment.same_structure?( test ).should be( bool )
          test.same_structure?( experiment ).should be( bool )
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

    end

  end
end
