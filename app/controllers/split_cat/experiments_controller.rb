module SplitCat
  class ExperimentsController < ApplicationController

    before_action :set_experiment, :only => [ :show ]

    def index
      @experiments = Experiment.order( 'id desc' )
    end

    def show
      respond_to do |format|
        format.html
        format.csv { render :text => @experiment.to_csv, :content_type => 'text/csv' }
      end
    end

  private

    def set_experiment
      @experiment = Experiment.includes( :goals, :hypotheses ).find( params[ :id ] )
    end

  end
end
