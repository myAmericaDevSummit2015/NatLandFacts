class Admin::BaseController < ApplicationController
  
  layout 'admin'
  before_filter :authenticate_admin!

  rescue_from ActiveRecord::RecordNotFound do
    flash[:warning] = "Element not found"
    redirect_to admin_root_path if !request.xhr?
  end
  
end
