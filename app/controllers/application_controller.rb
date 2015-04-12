class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected
  
  def check_referer_host
    if request.referer.nil? || request.host != URI.parse(request.referer).host
      render(nothing: true, status: :forbidden) and return
    end
  end

end
