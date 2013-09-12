class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :split_cat_token

  def split_cat_token
    unless cookies[ :split_cat_token ]
      cookies[ :split_cat_token ] = { :value => SplitCat::Subject.token, :expires => 10.years.from_now }
    end

    @split_cat_token = cookies[ :split_cat_token ]
  end

end
