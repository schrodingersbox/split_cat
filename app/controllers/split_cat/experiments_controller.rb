module SplitCat
  class ExperimentsController < ApplicationController
    before_action :set_experiment, only: [:show, :edit, :update, :destroy]

    # GET /experiments
    def index
      @name = params[ :name ]
      @active = ( params[ :active ] == '1' )

      @experiments = Experiment.order( 'id desc' )
      @experiments = @experiments.where( 'name like ?', '%' + @name + '%') if @name
    end

    # GET /experiments/1
    def show
      respond_to do |format|
        format.html
        format.csv { render :text => @experiment.to_csv, :content_type => 'text/csv' }
      end
    end

    # GET /experiments/new
    def new
      @experiment = Experiment.new
    end

    # GET /experiments/1/edit
    def edit
    end

    # POST /experiments
    def create
      @experiment = Experiment.new(experiment_params)

      if @experiment.save
        redirect_to @experiment, notice: 'Experiment was successfully created.'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /experiments/1
    def update
      if @experiment.update(experiment_params)
        redirect_to @experiment, notice: 'Experiment was successfully updated.'
      else
        render action: 'edit'
      end
    end

    # DELETE /experiments/1
    def destroy
      @experiment.destroy
      redirect_to experiments_url, notice: 'Experiment was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_experiment
        @experiment = Experiment.includes( :goals, :hypotheses ).find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def experiment_params
        params[:experiment].permit( Experiment.new.attributes.keys )
      end
  end
end
