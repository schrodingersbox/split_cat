require 'spec_helper'

include SplitCat

describe SplitCat::Config do

  let( :config ) { SplitCat::Config.instance }
  let( :empty ) { FactoryGirl.build( :experiment_empty ) }
  let( :full ) { FactoryGirl.build( :experiment_full ) }

  def setup_experiment
    config.experiment( full.name, full.description ) do |e|
      full.goals.each { |g| e.add_goal( g.name, g.description ) }
      full.hypotheses.each { |h| e.add_hypothesis( h.name, h.description, h.weight ) }
    end
  end

  it 'is a singleton' do
    config.should be( SplitCat::Config.instance )
  end

  #############################################################################
  # Config#initialize

  describe '#initialize' do

    it 'initializes the experiment cache' do
      config.send( :initialize )
      config.experiments.should eql( {} )
    end

  end

  #############################################################################
  # Config#experiment

  describe '#experiment' do

    it 'requires a block to yield to' do
      expect { config.experiment( empty.name ) } .to raise_error( LocalJumpError )
    end

    it 'yields a new initialized experiment' do
      config.experiment( empty.name, empty.description ) do |yielded|
        yielded.should be_new_record
        yielded.should be_an_instance_of( Experiment )
        yielded.name.should eql( empty.name )
        yielded.description.should eql( empty.description )
      end
    end

  end

  #############################################################################
  # Config#experiments

  describe '#experiments' do

    it 'returns the experiment cache' do
      setup_experiment
      config.experiments.should be_a_kind_of( Hash )
      config.experiments[ full.name.to_sym ].should be_present
    end

    it 'calls lookup on every new experiment in the cache' do
      config.experiments.clear
      full

      Experiment.should_receive( :new ).and_return( full )
      full.should_receive( :lookup ).and_return( nil )
      setup_experiment
      config.experiments
    end

    it 'only looks up new records' do
      config.experiments.clear
      full

      Experiment.should_receive( :new ).and_return( full )
      full.stub( :new_record? ).and_return( false )
      full.should_not_receive( :lookup )
      setup_experiment
      config.experiments
    end

  end

end