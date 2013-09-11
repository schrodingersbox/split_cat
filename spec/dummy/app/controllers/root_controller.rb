class RootController < ApplicationController

  def index
    @homepage_hypothesis = SplitCat.hypothesis( :homepage, @split_cat_token )
    @ad_hypothesis = SplitCat.hypothesis( :ad, @split_cat_token )
  end

  def token
    cookies[ :split_cat_token ] = { :value => SplitCat.token, :expires => 10.years.from_now }
    redirect_to :action => :index
  end

  def goals
    SplitCat.goal( :homepage, :clicked, @split_cat_token )
    SplitCat.goal( :ad, :clicked, @split_cat_token )
    redirect_to :action => :index
  end

end