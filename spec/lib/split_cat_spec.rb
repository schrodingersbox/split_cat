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

    it 'logs an error if the experiment is not cached' do
      Rails.logger.should_receive( :error ).with( 'SplitCat.goal failed to find experiment: does_not_exist' )
      SplitCat.goal( :does_not_exist, :goal_a, 'secret' ).should be_false
    end

    it 'calls record_goal on the experiment' do
      goal = :test
      token = 'secret'

      experiment = FactoryGirl.build( :experiment_full )
      SplitCat.config.should_receive( :experiments ).and_return( { experiment.name.to_sym => experiment } )

      experiment.should_receive( :record_goal ).with( goal, token ).and_return( true )
      SplitCat.goal( experiment.name.to_sym, goal, token ).should be_true
    end

  end

  #############################################################################
  # SplitCat::hypothesis

  describe '::hypothesis' do

    it 'returns false if the experiment is not cached' do
      SplitCat.hypothesis( :does_not_exist, 'secret' ).should be_nil
    end

    it 'logs an error if the experiment is not cached' do
      Rails.logger.should_receive( :error ).with( 'SplitCat.hypothesis failed to find experiment: does_not_exist' )
      SplitCat.hypothesis( :does_not_exist, 'secret' ).should be_false
    end

    it 'calls record_goal on the experiment' do
      setup_experiments

      @experiment.should_receive( :get_hypothesis ).with( @token ).and_return( @hypothesis )

      result = SplitCat.hypothesis( @experiment.name.to_sym, @token )
      @experiment.hypothesis_hash[ result ].should be_present
    end

  end

  #############################################################################
  # SplitCat::token

  describe '::token' do

    before( :each ) do
      @token = 'foobar'
    end

    it 'creates a new Subject and returns its token' do
      subject = SplitCat::Subject.create
      subject.should_receive( :token ).and_return( @token )
      SplitCat::Subject.should_receive( :create ).and_return( subject )

      SplitCat.token
    end

    it 'saves a provided token' do
      Subject.delete_all
      SplitCat.token( @token )
      Subject.find_by_token( @token ).should be_present
    end

  end

  #############################################################################
  # setup_experiments

  def setup_experiments
    @experiment = FactoryGirl.build( :experiment_full )
    @goal = @experiment.goals.first.name.to_sym
    @hypothesis = @experiment.hypotheses.first
    @token = 'secret'

    SplitCat.config.should_receive( :experiments ).and_return( { @experiment.name.to_sym => @experiment } )
  end

end