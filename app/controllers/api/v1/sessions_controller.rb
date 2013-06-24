class Api::V1::SessionsController < Devise::SessionsController

  def new
    render :status => 200,
           :json => { :success => true,
                      :info => "New session" }
  end

  def create
    # warden.authenticate!(:scope => resource_name, :store => false, :recall => "#{controller_path}#failure")
    email = params[:user]['email']
    password = params[:user]['password']

    build_resource
    resource = User.find_for_database_authentication(:email => email)

    unless resource
      render status: 401, json: { error: { title: t('user.errors.signin.email_not_found.title'), message: t('user.errors.signin.email_not_found.message', email: email) } } and return
    end

    unless resource.valid_password?(password)
      render status: 401, json: { error: { title: t('user.errors.signin.invalid_password.title'), message: t('user.errors.signin.invalid_password.message') } } and return
    end

    unless resource.active_for_authentication?
      render status: 401, json: { error: { title: t('user.errors.signin.account_disabled.title'), message: t('user.errors.signin.account_disabled.message') } } and return
    end
    
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged in",
                      :data => { :auth_token => current_user.authentication_token } }
  end

  def destroy
    current_user.try(:reset_authentication_token!)
    render :status => 200,
           :json => { :success => true,
                      :info => "Logged out",
                      :data => {} }
  end

  # Other code
end