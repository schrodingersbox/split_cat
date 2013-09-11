require 'spec_helper'

include SplitCat

describe 'split_cat/experiments/show.html.erb' do

  before( :each ) do
    assign( :experiment, FactoryGirl.build( :experiment_full ) )
    assign( :hypothesis_counts, {} )
  end

  it 'renders without exception' do
    pending 'Problem with named routes under rspec, but fine in server - views are getting app routes, rather than engine routes'
    render
  end

end