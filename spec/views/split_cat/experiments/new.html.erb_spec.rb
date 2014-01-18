require 'spec_helper'

describe "split_cat/experiments/new" do

  let( :experiment ) { FactoryGirl.build( :experiment_full ) }

  before(:each) do
    stub_view_routes

    assign(:experiment, experiment )
  end

  it "renders new experiment form" do
    render
  end
end
