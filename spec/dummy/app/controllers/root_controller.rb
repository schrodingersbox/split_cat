class RootController < ApplicationController

  def index
    @homepage_hypothesis = split_cat_hypothesis( HOMEPAGE_EXPERIMENT, @split_cat_token )
    @ad_hypothesis = split_cat_hypothesis( AD_EXPERIMENT, @split_cat_token )
  end

  def token
    cookies[ :split_cat_token ] = { :value => split_cat_token, :expires => 10.years.from_now }
    redirect_to :action => :index
  end

  def goals
    split_cat_goal( HOMEPAGE_EXPERIMENT, :clicked, @split_cat_token )
    split_cat_goal( AD_EXPERIMENT, :clicked, @split_cat_token )
    redirect_to :action => :index
  end

end