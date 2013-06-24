class Api::V1::RegistrationsController < Devise::RegistrationsController
  # Other code

  def create
    build_resource
    # resource.skip_confirmation!
    if resource.save
      sign_in(resource, :store => false)
      resource.reset_authentication_token!
      render :status => 200,
           :json => { :success => true,
                      :info => "Registered",
                      :data => { :user => resource,
                                 :auth_token => current_user.authentication_token } }
    else
      render status: :unprocessable_entity, json: { error: { title: t('user.errors.signup.generic.title'), message: resource.errors.first.last } } and return
      # render :status => :unprocessable_entity,
      #        :json => { :success => false,
      #                   :info => resource.errors,
      #                   :data => {} }
    end
  end
end