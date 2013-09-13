require 'spec_helper'

include SplitCat

describe SplitCat::Config do

  let( :config ) { SplitCat::Config.instance }

  before( :each ) do
    @name = :test
    @description = 'this is only a test'
    @weight = 727
    @hypothesis = :hypothesis_a
    @goal = :goal_a

    config.experiments.clear
  end

  it 'is a singleton' do
    config.should be( SplitCat::Config.instance )
  end

  describe 'attributes' do

    it 'has a cookie_expiration' do
      cookie_expiration = 10.years
      config.cookie_expiration = cookie_expiration
      config.cookie_expiration.to_s.should eql( cookie_expiration.to_s )
    end

  end

  #############################################################################
  # Config#initialize

  describe '#initialize' do

    it 'initializes the experiment config hash' do
      config.send( :initialize )
      config.cookie_expiration.to_s.should eql( 10.years.to_s )
      config.experiments.should be_an_instance_of( HashWithIndifferentAccess )
    end

  end

  #############################################################################
  # Config#experiment

  describe '#experiment' do

    it 'creates an entry in the experiments config hash' do
      config.experiment( @name, @description ) {}

      result = config.experiments[ @name ]
      result.should be_present
      result[ :experiment ][ :name ].should eql( @name )
      result[ :experiment ][ :description ].should eql( @description )
      result[ :goals ].should eql( [] )
      result[ :hypotheses ].should eql( [] )
    end

    it 'yields itself' do
      config.experiment( @name, @description ) do |yielded|
        yielded.should be( config )
      end
    end

  end

  #############################################################################
  # Config#hypothesis

  describe '#hypothesis' do

    it 'appends a hypothesis on the current experiment' do
      config.experiment( @name, @description ) do |c|
        c.hypothesis( @hypothesis, @weight, @description )
      end

      result = config.experiments[ @name ][ :hypotheses ].first
      result.should be_present
      result[ :name ].should eql( @hypothesis )
      result[ :weight ].should eql( @weight )
      result[ :description ].should eql( @description )
    end

  end

  #############################################################################
  # Config#goal

  describe '#goal' do

    it 'appends a goal on the current experiment' do
      config.experiment( @name, @description ) do |c|
        c.goal( @goal, @description )
      end

      result = config.experiments[ @name ][ :goals ].first
      result.should be_present
      result[ :name ].should eql( @goal )
      result[ :description ].should eql( @description )
    end

  end

  #############################################################################
  # Config#template

  describe '#template' do

    it 'returns nil if the experiment is not configured' do
      config.template( :does_not_exist ).should be_nil
    end

    it 'creates a new experiment from the config values' do
      config.experiment( @name, @description ) do |c|
        c.goal( @goal, @description )
        c.hypothesis( @hypothesis, @weight, @description )
      end

      experiment = config.template( @name )
      hypothesis = experiment.hypotheses.first
      goal = experiment.goals.first

      experiment.name.should eql( @name )
      experiment.description.should eql( @description )

      hypothesis.name.should eql( @hypothesis )
      hypothesis.description.should eql( @description )
      hypothesis.weight.should eql( @weight )

      goal.name.should eql( @goal )
      goal.description.should eql( @description )
    end

  end

end