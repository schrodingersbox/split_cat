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

    context 'when the experiment is not in db' do

      it 'creates an experiment' do
        Experiment.find_by_name( full.name ).should be_nil
        setup_experiment
        Experiment.find_by_name( full.name ).should be_present
      end

    end

    context 'when experiment is in db' do

      it 'caches it if the structures match between config and db' do
        config.experiments.clear
        FactoryGirl.create( :experiment_full )
        setup_experiment
        config.experiments[ full.name.to_sym ].should be_present
      end

      it 'raises an exception if the structures do not match between config and db' do
        experiment = FactoryGirl.create( :experiment_full )
        experiment.goals.delete( experiment.goals.first )

        expect { setup_experiment }.to raise_error
      end

    end

  end

end