class RootController < ApplicationController

  def index
    @homepage_hypothesis = params[ :homepage_hypothesis ] || split_cat_hypothesis( HOMEPAGE_EXPERIMENT, @split_cat_token )
    @ad_hypothesis = params[ :ad_hypothesis ] || split_cat_hypothesis( AD_EXPERIMENT, @split_cat_token )
  end

  def token
    set_split_cat_cookie :force => true
    redirect_to :action => :index
  end

  def goals
    set_split_cat_cookie :force => true
    split_cat_goal( HOMEPAGE_EXPERIMENT, :clicked, @split_cat_token )
    split_cat_goal( AD_EXPERIMENT, :clicked, @split_cat_token )
    redirect_to :action => :index
  end

end