class Api::V1::Users::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

  def sign_up_params
    params.permit(:name, :email, :phone, :birthday, :password, :password_confirmation)
  end
end