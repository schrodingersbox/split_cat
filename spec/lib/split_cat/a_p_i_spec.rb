require 'spec_helper'

module SplitCat

  describe API do

    include SplitCat::API

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
    # #hypothesis

    describe '#split_cat_factory' do

      context 'when experiment is not configured' do

        before( :each ) do
          config.experiments.clear
        end

        it 'returns nil' do
          split_cat_factory( :does_not_exist ).should be_nil
        end

        it 'logs an error' do
          Rails.logger.should_receive( :error )
          split_cat_factory( :does_not_exist ).should be_nil
        end

      end

      context 'when experiment is configured' do

        before( :each ) do
          config.experiment( experiment.name ) do |c|
            experiment.hypotheses.each { |h| c.hypothesis( h.name, h.weight ) }
            experiment.goals.each { |g| c.goal( g.name ) }
          end
        end

        context 'and saved' do

          before( :each ) do
            experiment.save!

            Experiment.should_receive( :includes ).and_return( experiment )
            experiment.should_receive( :find_by_name ).and_return( experiment )
          end

          it 'loads it from the database' do
            split_cat_factory( experiment.name ).should be( experiment )
          end

          it 'returns nil and logs an error if the db and config structures do not match' do
            experiment.should_receive( :same_structure? ).and_return( false )
            Rails.logger.should_receive( :error )
            split_cat_factory( experiment.name ).should be_nil
          end

          it 'returns the experiment if the structures match' do
            experiment.should_receive( :same_structure? ).and_return( true )
            split_cat_factory( experiment.name ).should be( experiment )
          end

        end

        context 'and not saved' do

          it 'returns the experiment if the save is successful' do
            SplitCat.config.should_receive( :experiment_factory ).with( experiment.name ).and_return( experiment )
            experiment.should_receive( :save ).and_return( true )
            split_cat_factory( experiment.name ).should be( experiment )
          end

          it 'returns nil and logs an error if it is unable to save' do
            SplitCat.config.should_receive( :experiment_factory ).with( experiment.name ).and_return( experiment )
            experiment.should_receive( :save ).and_return( false )
            Rails.logger.should_receive( :error )
            split_cat_factory( experiment.name ).should be( nil )
          end

        end

      end

    end

    #############################################################################
    # setup_experiments

    def setup_experiments
      @experiment = FactoryGirl.create( :experiment_full )
      @goal = @experiment.goals.first.name.to_sym
      @hypothesis = @experiment.hypotheses.first
      @token = 'secret'

      should_receive( :split_cat_factory ).and_return( @experiment )
    end

  end

end