class ApplicationController < ActionController::Base
  NotAuthorized = Class.new(StandardError)

  before_action :store_location

  def store_location
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/ || request.fullpath =~ /\A\/\z/
  end

  # redirect user to the originally requested page after sign in
  def after_sign_in_path_for(resource)
    session[:previous_url] || activities_path
  end

  rescue_from ApplicationController::NotAuthorized do |exception|
    render_error_page(status: 403, text: 'Forbidden', message: 'The page you were looking for requires authorization.')
  end

  private

  def render_error_page(status:, text:, message:, template: 'errors/routing')
    respond_to do |format|
      format.json { render json: {errors: [message: "#{status} #{text}"]}, status: status }
      format.html { render :template => template, :locals => {:message => message, :status => status, :text => text}, :status => status, :layout => false }
      format.any  { head status }
    end
  end
end