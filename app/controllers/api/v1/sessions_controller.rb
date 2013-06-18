class Api::V1::SessionsController < Devise::SessionsController

  def new
    render :status => 200,
           :json => { :success => true,
                      :info => "New session" }
  end

  def create
    warden.authenticate!(:scope => resource_name, :store => false, :recall => "#{controller_path}#failure")
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged in",
                      :data => { :auth_token => current_user.authentication_token } }
  end

  def destroy
    current_user.reset_authentication_token!
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :data => {} }
  end

  # Other code
end