require 'spec_helper'

module SplitCat
  describe ExperimentsController do

    routes { SplitCat::Engine.routes }

    let( :experiment ) { FactoryGirl.create( :experiment_full ) }
    let(:valid_attributes) { { :name => 'valid'  } }
    let(:valid_session) { {} }

    it 'is a subclass of ApplicationController' do
      @controller.should be_a_kind_of( ApplicationController )
    end

    before( :each ) do
      controller.stub( :require_login )
      expect( experiment ).to be_present
    end

    describe "GET index" do
      it "assigns all experiments as @experiments" do
        get :index, {}, valid_session
        assigns(:experiments).should eq([experiment])
      end

      it 'accepts name and active params' do
        name = experiment.name
        active = '1'
        get :index, :name => name, :active => active

        expect( assigns( :name ) ).to be( name )
        expect( assigns( :active ) ).to eql( active == '1' )
      end
    end

    describe "GET show" do
      it "assigns the requested experiment as @experiment" do
        get :show, {:id => experiment.to_param}, valid_session
        assigns(:experiment).should eq(experiment)
      end

      context 'formatting CSV' do

        it 'renders CSV' do
          get :show, :id => experiment.id, :format => 'csv'
          response.should be_success
          response.content_type.should eql( 'text/csv' )
        end

        it 'turns the requested experiment into CSV' do
          get :show, :id => experiment.id, :format => 'csv'
          response.body.should eql( experiment.to_csv )
        end

      end

      context 'formatting HTML' do

        it 'renders HTML' do
          get :show, :id => experiment.id, :format => 'html'
          response.should be_success
          response.content_type.should eql( 'text/html' )
        end

      end
    end

    describe "GET new" do
      it "assigns a new experiment as @experiment" do
        get :new, {}, valid_session
        assigns(:experiment).should be_a_new(Experiment)
      end
    end

    describe "GET edit" do
      it "assigns the requested experiment as @experiment" do
        get :edit, {:id => experiment.to_param}, valid_session
        assigns(:experiment).should eq(experiment)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Experiment" do
          expect {
            post :create, {:experiment => valid_attributes}, valid_session
          }.to change(Experiment, :count).by(1)
        end

        it "assigns a newly created experiment as @experiment" do
          post :create, {:experiment => valid_attributes}, valid_session
          assigns(:experiment).should be_a(Experiment)
          assigns(:experiment).should be_persisted
        end

        it "redirects to the created experiment" do
          post :create, {:experiment => valid_attributes}, valid_session
          response.should redirect_to(Experiment.last)
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved experiment as @experiment" do
          # Trigger the behavior that occurs when invalid params are submitted
          Experiment.any_instance.stub(:save).and_return(false)
          post :create, {:experiment => {  }}, valid_session
          assigns(:experiment).should be_a_new(Experiment)
        end

        it "re-renders the 'new' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Experiment.any_instance.stub(:save).and_return(false)
          post :create, {:experiment => {  }}, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested experiment" do
          experiment = Experiment.create! valid_attributes
          # Assuming there are no other experiments in the database, this
          # specifies that the Experiment created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Experiment.any_instance.should_receive(:update).with({ "name" => "params" })
          put :update, {:id => experiment.to_param, :experiment => { "name" => "params" }}, valid_session
        end

        it "assigns the requested experiment as @experiment" do
          put :update, {:id => experiment.to_param, :experiment => valid_attributes}, valid_session
          assigns(:experiment).should eq(experiment)
        end

        it "redirects to the experiment" do
          put :update, {:id => experiment.to_param, :experiment => valid_attributes}, valid_session
          response.should redirect_to(experiment)
        end
      end

      describe "with invalid params" do
        it "assigns the experiment as @experiment" do
          experiment = Experiment.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Experiment.any_instance.stub(:save).and_return(false)
          put :update, {:id => experiment.to_param, :experiment => {  }}, valid_session
          assigns(:experiment).should eq(experiment)
        end

        it "re-renders the 'edit' template" do
          experiment = Experiment.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          Experiment.any_instance.stub(:save).and_return(false)
          put :update, {:id => experiment.to_param, :experiment => {  }}, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested experiment" do
        expect {
          delete :destroy, {:id => experiment.to_param}, valid_session
        }.to change(Experiment, :count).by(-1)
      end

      it "redirects to the experiments list" do
        delete :destroy, {:id => experiment.to_param}, valid_session
        response.should redirect_to(experiments_url)
      end
    end

  end
end
