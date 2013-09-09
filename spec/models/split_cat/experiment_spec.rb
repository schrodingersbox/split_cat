require 'spec_helper'

module SplitCat
  describe Experiment do

    before( :each ) do
      @experiment = FactoryGirl.build( :empty_experiment )
    end

    describe 'associations' do

      it 'has many goals' do
        @experiment = FactoryGirl.create( :empty_experiment )
        @goal_a = FactoryGirl.create( :goal_a, :experiment => @experiment )
        @goal_b = FactoryGirl.create( :goal_b, :experiment => @experiment )

        @experiment.goals.count.should eql( 2 )
      end

      it 'has many hypotheses' do
        @experiment = FactoryGirl.create( :empty_experiment )
        @hypothesis_a = FactoryGirl.create( :hypothesis_a, :experiment => @experiment )
        @hypothesis_b = FactoryGirl.create( :hypothesis_b, :experiment => @experiment )

        @experiment.hypotheses.count.should eql( 2 )
      end

    end

    describe 'attributes' do

      it 'has a name' do
        name = FactoryGirl.build( :empty_experiment ).name
        @experiment.name = name
        @experiment.name.should eql( name )
      end

      it 'has a description' do
        description = FactoryGirl.build( :empty_experiment ).description
        @experiment.description = description
        @experiment.description.should eql( description )
      end

      it 'has a created_at' do
        created_at = FactoryGirl.build( :empty_experiment ).created_at
        @experiment.created_at = created_at
        @experiment.created_at.should eql( created_at )
      end
    end

    describe 'constraints' do

      it 'validates the presence of name' do
        @experiment.valid?.should be_true
        @experiment.name = nil
        @experiment.valid?.should be_false
        @experiment.errors.messages[ :name ].should eql( ["can't be blank"] )
      end

      it 'validates the uniqueness of name' do
        FactoryGirl.create( :empty_experiment )

        @experiment.valid?.should be_false
        @experiment.errors.messages[ :name ].should eql( ["has already been taken"] )
      end

    end

  end
end
