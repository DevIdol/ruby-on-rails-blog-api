class UserService
  def initialize(user, params)
    @user = user
    @params = params
  end

  def update_user
    if update_username? && update_password?
      handle_username_and_password_update
    elsif update_username?
      handle_username_update
    elsif update_password?
      handle_password_update
    else
      { message: "No valid fields to update", status: :unprocessable_entity }
    end
  end

  private

  def update_username?
    @params[:username].present?
  end

  def update_password?
    @params[:password].present? && @params[:old_password].present?
  end

  def handle_username_and_password_update
    if @user.valid_password?(@params[:old_password])
      if @user.update(user_params)
        { message: "Account updated successfully", status: :ok }
      else
        { message: "Failed to update account", status: :unprocessable_entity }
      end
    else
      { message: "Old password is incorrect", status: :unprocessable_entity }
    end
  end

  def handle_username_update
    if @user.update(username: @params[:username])
      { message: "Username updated successfully", status: :ok }
    else
      { message: "Failed to update username", status: :unprocessable_entity }
    end
  end

  def handle_password_update
    if @user.valid_password?(@params[:old_password])
      if @user.update(password: @params[:password], password_confirmation: @params[:password_confirmation])
        { message: "Password updated successfully", status: :ok }
      else
        { message: "Failed to update password", status: :unprocessable_entity }
      end
    else
      { message: "Old password is incorrect", status: :unprocessable_entity }
    end
  end

  def user_params
    @params.permit(:email, :password, :password_confirmation, :username)
  end
end
