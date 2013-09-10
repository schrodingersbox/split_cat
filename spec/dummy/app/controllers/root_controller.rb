class RootController < ApplicationController

  def index
    @homepage_hypothesis = SplitCat.hypothesis( :homepage, @split_cat_token )
    @ad_hypothesis = SplitCat.hypothesis( :ad, @split_cat_token )
  end

  def goal
    SplitCat.goal( :homepage, :clicked, @split_cat_token )
    SplitCat.goal( :ad, :clicked, @split_cat_token )
  end

end