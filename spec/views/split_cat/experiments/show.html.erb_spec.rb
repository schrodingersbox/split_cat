require 'spec_helper'

include SplitCat

describe 'split_cat/experiments/show.html.erb' do

  before( :each ) do
    stub_view_routes

    assign( :experiment, FactoryGirl.create( :experiment_full ) )
    assign( :hypothesis_counts, {} )
  end

  it 'renders without exception' do
    render
  end

end