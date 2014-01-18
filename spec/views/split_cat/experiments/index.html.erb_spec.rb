require 'spec_helper'

describe "split_cat/experiments/index" do

  let( :experiment ) { FactoryGirl.create( :experiment_full ) }

  before(:each) do
    stub_view_routes

    assign(:experiments, [ experiment, experiment ])
  end

  it "renders a list of experiments" do
    render
  end
end
