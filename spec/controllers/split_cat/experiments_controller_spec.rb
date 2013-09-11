require 'spec_helper'

describe SplitCat::ExperimentsController do

  routes { SplitCat::Engine.routes }

  it 'is a subclass of ApplicationController' do
    @controller.should be_a_kind_of( ApplicationController )
  end

  describe '/get' do

    it 'gets successfully' do
      get :index
      response.should be_success
    end

    it 'assigns experiments' do
      FactoryGirl.create( :experiment_full )
      get :index
      response.should be_success
      expect( assigns( :experiments ) ).to be_present
    end

  end

end