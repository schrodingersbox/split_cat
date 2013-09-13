module SplitCat
  class ExperimentsController < ApplicationController

    before_action :set_experiment, :only => [ :show ]

    def index
      @name = params[ :name ]
      @active = ( params[ :active ] == '1' )

      @experiments = Experiment.order( 'id desc' )
      @experiments = @experiments.where( 'name like ?', '%' + @name + '%') if @name

      @experiments = @experiments.map { |e| e.active? ? e : nil }.compact if @active
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
