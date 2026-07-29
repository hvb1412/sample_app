class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by(email: params.dig(:session, :email)&.downcase)
    if user&.authenticate(params.dig(:session, :password))
      log_in user
      flash[:success] = t("flash.success.login")
      redirect_to user_path(user, locale: I18n.locale)
    else
      flash.now[:danger] = t("flash.danger.invalid_email_password")
      render :new
    end
  end

  def destroy
    log_out
    flash[:success] = t("flash.success.logout")
    redirect_to root_path(locale: I18n.locale)
  end
end
