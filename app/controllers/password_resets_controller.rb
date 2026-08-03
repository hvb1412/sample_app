class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)
  def new; end

  def create
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    if @user
      @user.create_reset_digest
      @user.send_password_resent_email(params[:locale])
      flash[:info] = t("password_resets.create.create_info")
      redirect_to root_path(locale: I18n.locale)
    else
      flash.now[:danger] = t("password_resets.create.create_danger")
      render :new
    end
  end

  def edit; end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t(".error")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t("flash.success.pwd_change_success")
      redirect_to user_path(@user, locale: I18n.locale)
    end
  end

  private
  def user_params
    params.require(:user).permit :password, :passwrod_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t("flash.danger.user_not_found")
    redirect_to root_url(locale: I18n.locale)
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t("flash.danger.inactive")
    redirect_to root_url(locale: I18n.locale)
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t("flash.danger.check_pwd_expired")
    redirect_to new_password_reset_url(locale: I18n.locale)
  end
end
