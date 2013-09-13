require 'spec_helper'

module SplitCat

  describe Helpers do

    include SplitCat::Helpers

    let( :config ) { SplitCat::Config.instance }
    let( :experiment ) { FactoryGirl.build( :experiment_full ) }

    #############################################################################
    # #token

    describe '#split_cat_token' do

      before( :each ) do
        @token = 'foobar'
      end

      it 'creates a new Subject and returns its token' do
        subject = SplitCat::Subject.create
        subject.should_receive( :token ).and_return( @token )
        SplitCat::Subject.should_receive( :create ).and_return( subject )

        split_cat_token
      end

      it 'saves a provided token' do
        Subject.delete_all
        split_cat_token( @token )
        Subject.find_by_token( @token ).should be_present
      end

    end

    #############################################################################
    # #goal

    describe '#split_cat_goal' do

      it 'returns false if the experiment is not cached' do
        split_cat_goal( :does_not_exist, :goal_a, 'secret' ).should be_false
      end

      it 'logs an error if the experiment is not cached' do
        Rails.logger.should_receive( :error ).at_least(1).times
        split_cat_goal( :does_not_exist, :goal_a, 'secret' ).should be_false
      end

      it 'calls record_goal on the experiment' do
        setup_experiments
        goal = :test

        @experiment.should_receive( :record_goal ).with( goal, @token ).and_return( true )
        split_cat_goal( @experiment.name.to_sym, goal, @token ).should be_true
      end

    end

    #############################################################################
    # #hypothesis

    describe '#split_cat_hypothesis' do

      it 'returns false if the experiment is not cached' do
        split_cat_hypothesis( :does_not_exist, 'secret' ).should be_nil
      end

      it 'logs an error if the experiment is not cached' do
        Rails.logger.should_receive( :error ).at_least(1).times
        split_cat_hypothesis( :does_not_exist, 'secret' ).should be_false
      end

      it 'calls get_hypothesis on the experiment' do
        setup_experiments
        @experiment.should_receive( :get_hypothesis ).with( @token ).and_return( @hypothesis )

        result = split_cat_hypothesis( @experiment.name.to_sym, @token )
        @experiment.hypothesis_hash[ result ].should be_present
      end

    end

    #############################################################################
    # #set_split_cat_cookie

    describe '#set_split_cat_cookie' do

      before( :each ) do
        @cookies = {}
        should_receive( :cookies ).at_least(1).times.and_return( @cookies )
      end

      it 'sets the split_cat_token instance variable' do
        set_split_cat_cookie
        @split_cat_token.should be_present
      end

      it 'assigns a cookie if one is not already set' do
        set_split_cat_cookie
        @cookies.size.should eql( 1)
      end

      it 'assigns a cookie when passed the :force option' do
        token = set_split_cat_cookie
        set_split_cat_cookie.should eql( token )
        set_split_cat_cookie( :force => true ).should_not eql( token )
      end

      it 'uses the configured cookie expiration time' do
        expires = 1.years.ago
        SplitCat.config.cookie_expiration.should_receive( :from_now ).and_return( expires )
        set_split_cat_cookie
        cookies.values.first[ :expires ].should eql( expires )
      end

    end

    #############################################################################
    # setup_experiments

    def setup_experiments
      @experiment = FactoryGirl.create( :experiment_full )
      @goal = @experiment.goals.first.name.to_sym
      @hypothesis = @experiment.hypotheses.first
      @token = 'secret'

      Experiment.should_receive( :factory ).and_return( @experiment )
    end

  end

end