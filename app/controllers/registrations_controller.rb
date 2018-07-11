class RegistrationsController < Devise::RegistrationsController

  protected

  # redirect to activities after an account update
  def after_update_path_for(resource)
    activities_path
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
  end
end