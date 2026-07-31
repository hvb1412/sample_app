class AccountActivationsController < ApplicationController
  before_action :find_user

  def edit
    if valid_activation?
      activate_user
    else
      invalid_activation
    end
  end

  private

  def find_user
    @user = User.find_by(email: params[:email])

    return if @user

    flash[:danger] = t("flash.danger.user_not_found")
    redirect_to login_path(locale: I18n.locale)
  end

  def valid_activation?
    @user && !@user.activated && @user.authenticated?(:activation, params[:id])
  end

  def activate_user
    @user.activate
    log_in @user
    flash[:success] = t("flash.success.activated")
    redirect_to user_path(@user, locale: I18n.locale)
  end

  def invalid_activation
    flash[:danger] = t("flash.danger.invalid_activation")
    redirect_to root_url(locale: I18n.locale)
  end
end
