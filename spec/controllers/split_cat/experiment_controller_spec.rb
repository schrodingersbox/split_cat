require 'spec_helper'

describe SplitCat::ExperimentController do

  routes { SplitCat::Engine.routes }

  it 'is a subclass of ApplicationController' do
    @controller.should be_a_kind_of( ApplicationController )
  end


end