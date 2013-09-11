class RootController < ApplicationController

  def index
    @homepage_hypothesis = SplitCat.hypothesis( :homepage_1, @split_cat_token )
    @ad_hypothesis = SplitCat.hypothesis( :ad_1, @split_cat_token )
  end

  def token
    cookies[ :split_cat_token ] = { :value => SplitCat.token, :expires => 10.years.from_now }
    redirect_to :action => :index
  end

  def goals
    SplitCat.goal( :homepage_1, :clicked, @split_cat_token )
    SplitCat.goal( :ad_1, :clicked, @split_cat_token )
    redirect_to :action => :index
  end

end