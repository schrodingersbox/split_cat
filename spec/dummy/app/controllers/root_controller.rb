class RootController < ApplicationController

  def index
    @homepage_hypothesis = SplitCat::Experiment.hypothesis( HOMEPAGE_EXPERIMENT, @split_cat_token )
    @ad_hypothesis = SplitCat::Experiment.hypothesis( AD_EXPERIMENT, @split_cat_token )
  end

  def token
    cookies[ :split_cat_token ] = { :value => SplitCat.token, :expires => 10.years.from_now }
    redirect_to :action => :index
  end

  def goals
    SplitCat::Experiment.goal( HOMEPAGE_EXPERIMENT, :clicked, @split_cat_token )
    SplitCat::Experiment.goal( AD_EXPERIMENT, :clicked, @split_cat_token )
    redirect_to :action => :index
  end

end