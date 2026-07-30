class SessionsController < ApplicationController
  def new; end

  def create
    user = find_user
    if user.try(:authenticate, params.dig(:session, :password))
      log_in user
      params.dig(:session, :remember_me) == "1" ? remember(user) : forget(user)
      flash[:success] = t("flash.success.login")
      redirect_to user_path(user, locale: I18n.locale)
    else
      render_login_error
    end
  end

  def destroy
    log_out
    flash[:success] = t("flash.success.logout")
    redirect_to root_path(locale: I18n.locale)
  end

  private

  def find_user
    User.find_by(email: params.dig(:session, :email)&.downcase)
  end

  def render_login_error
    flash.now[:danger] = t("flash.danger.invalid_email_password")
    render :new
  end
end
