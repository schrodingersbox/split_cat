module SplitCat
  class ExperimentsController < ApplicationController

    before_action :set_experiment, :only => [ :show ]

    def index
      @experiments = Experiment.all
    end

    def show
    end

  private

    def set_experiment
      @experiment = Experiment.includes( :goals, :hypotheses ).find( params[ :id ] )
    end

  end
end
