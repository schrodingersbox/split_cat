require 'spec_helper'

describe "split_cat/experiments/edit" do

  let( :experiment ) { FactoryGirl.create( :experiment_full ) }

  before(:each) do
    stub_view_routes

    assign(:experiment, experiment )
  end

  it "renders the edit experiment form" do
    render
  end
end
