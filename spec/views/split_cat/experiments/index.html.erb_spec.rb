require 'spec_helper'

include SplitCat

describe 'split_cat/experiments/index.html.erb' do

  before( :each ) do
    assign( :experiments, Experiment.all )
  end

  it 'renders without exception' do
    render
  end

end