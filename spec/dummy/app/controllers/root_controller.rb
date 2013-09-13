class RootController < ApplicationController

  before_filter :setup_hypothesis, :only => [ :index ]

  def index
    @hypothesis = params[ :hypothesis ]
    @hypothesis ||= split_cat_hypothesis( HOMEPAGE_EXPERIMENT, @split_cat_token )
  end

  def token
    set_split_cat_cookie :force => true
    redirect_to :action => :index
  end

  def goals
    split_cat_goal( HOMEPAGE_EXPERIMENT, :clicked, @split_cat_token )
    set_split_cat_cookie :force => true
    redirect_to :action => :index
  end

  def login
    cookies[ :login ] = { :value => true, :expires => 10.years.from_now }
    redirect_to :action => :index
  end

  def logout
    cookies.delete( :login )
    redirect_to :action => :index
  end

  def unauthorized
  end

protected

  def setup_hypothesis
    @hypothesis = params[ :hypothesis ]
    @hypothesis ||= split_cat_hypothesis( HOMEPAGE_EXPERIMENT, @split_cat_token )
  end

end