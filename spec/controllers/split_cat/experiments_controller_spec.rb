require 'spec_helper'

describe SplitCat::ExperimentsController do

  routes { SplitCat::Engine.routes }

  it 'is a subclass of ApplicationController' do
    @controller.should be_a_kind_of( ApplicationController )
  end

  before( :each ) do
    @experiment = FactoryGirl.create( :experiment_full )
  end

  describe '/index' do

    it 'gets successfully' do
      get :index
      response.should be_success
    end

    it 'assigns experiments' do
      get :index
      response.should be_success
      expect( assigns( :experiments ) ).to be_present
    end

  end

  describe '/show' do

    it 'gets successfully' do
      pending 'route problem'
      get :show
      response.should be_success
    end

    it 'assigns hypothesis and goal counts' do
      pending 'route problem'
      get :show, :id => @experiment.id

      response.should be_success
      expect( assigns( :hypothesis_counts ) ).to be_present
      expect( assigns( :goal_counts ) ).to be_present
    end

  end

end