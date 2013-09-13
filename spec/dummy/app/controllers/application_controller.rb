class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :set_split_cat_cookie

  def require_login
    redirect_to '/unauthorized' unless cookies[ :login ]
  end

end
