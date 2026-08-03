class SessionsController < ApplicationController
  def new; end

  def create
    user = find_user

    return render_login_error unless authenticated?(user)
    return redirect_not_activated unless user.activated

    login_user(user)
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

  def authenticated? user
    user&.authenticate(params.dig(:session, :password))
  end

  def login_user user
    log_in user
    remember_or_forget(user)
    flash[:success] = t("flash.success.login")
    redirect_back_or user_path(user, locale: I18n.locale)
  end

  def remember_or_forget user
    if params.dig(:session, :remember_me) == "1"
      remember(user)
    else
      forget(user)
    end
  end

  def redirect_not_activated
    flash[:warning] = t("flash.warning.not_activate")
    redirect_to root_url(locale: I18n.locale)
  end

  def render_login_error
    flash.now[:danger] = t("flash.danger.invalid_email_password")
    render :new
  end
end
