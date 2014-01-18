require 'spec_helper'

describe "split_cat/experiments/show" do

  let( :experiment ) { FactoryGirl.create( :experiment_full ) }

  before(:each) do
    stub_view_routes

    assign( :experiment, experiment )
  end

  it "renders" do
    render
  end
end
