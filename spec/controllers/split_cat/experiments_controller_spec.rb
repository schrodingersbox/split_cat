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

    it 'accepts name and active params' do
      name = @experiment.name
      active = '1'
      get :index, :name => name, :active => active

      expect( assigns( :name ) ).to be( name )
      expect( assigns( :active ) ).to eql( active == '1' )
    end

  end

  describe '/show' do

    it 'gets successfully' do
      get :show, :id => @experiment.id
      response.should be_success
    end

    it 'assigns experiments' do
      get :show, :id => @experiment.id
      response.should be_success
      expect( assigns( :experiment ) ).to be_present
    end

    context 'formatting CSV' do

      it 'renders CSV' do
        get :show, :id => @experiment.id, :format => 'csv'
        response.should be_success
        response.content_type.should eql( 'text/csv' )
      end

      it 'turns the requested experiment into CSV' do
        get :show, :id => @experiment.id, :format => 'csv'
        response.body.should eql( @experiment.to_csv )
      end

    end

    context 'formatting HTML' do

      it 'renders HTML' do
        get :show, :id => @experiment.id, :format => 'html'
        response.should be_success
        response.content_type.should eql( 'text/html' )
      end

    end

  end

end