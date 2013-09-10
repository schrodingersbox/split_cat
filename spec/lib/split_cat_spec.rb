require 'spec_helper'

include SplitCat

describe SplitCat do

  it 'requires the engine' do
    SplitCat::Engine.should_not be_nil
  end

  it 'defines the SplitCat module' do
    SplitCat.should_not be_nil
  end

  #############################################################################
  # SplitCat::config

  describe '::config' do

    it 'returns the configuration' do
      SplitCat.config.should be_an_instance_of( SplitCat::Config )
    end

  end

  #############################################################################
  # SplitCat::configure

  describe '::configure' do

    it 'yields the configuration' do
      SplitCat.configure { |config| config.should be_an_instance_of( SplitCat::Config ) }
    end

  end

  #############################################################################
  # SplitCat::goal

  describe '::goal' do

    it 'returns false if the experiment is not cached' do
      SplitCat.goal( :does_not_exist, :goal_a, 'secret' ).should be_false
    end

    it 'calls record_goal on the experiment' do
      goal = :test
      token = 'secret'
      @experiment = FactoryGirl.build( :experiment_full )
      @experiment.should_receive( :record_goal ).with( goal, token ).and_return( true )
      SplitCat.config.should_receive( :experiments ).and_return( { @experiment.name.to_sym => @experiment } )
      SplitCat.goal( @experiment.name.to_sym, goal, token ).should be_true
    end

  end

  #############################################################################
  # SplitCat::hypothesis

  describe '::hypothesis' do

    it 'needs to be specced'

  end

  #############################################################################
  # SplitCat::token

  describe '::token' do

    it 'creates a new Subject and returns its token' do
      subject = SplitCat::Subject.create
      subject.should_receive( :token ).and_return( 'foobar' )
      SplitCat::Subject.should_receive( :create ).and_return( subject )

      SplitCat::Subject.create.token
    end

  end

end