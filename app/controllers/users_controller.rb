class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(edit update destroy)
  before_action :find_user, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @pagy, @users = pagy(User.latest, Settings.pagy.items)
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      reset_session
      log_in @user
      flash[:success] = t("flash.success.create")
      redirect_to user_path(@user, locale: I18n.locale)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t("flash.success.update")
      redirect_to user_path(@user, locale: I18n.locale)
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t("flash.success.deleted")
    else
      flash[:danger] = t("flash.success.delete_fail")
    end
    redirect_to users_url(locale: I18n.locale)
  end

  private
  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

  def find_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t("flash.danger.user_not_found")
    redirect_to root_path(locale: I18n.locale)
  end

  def correct_user
    return if current_user?(@user)

    flash[:warning] = t("flash.error.not_current_user")
    redirect_to root_url(locale: I18n.locale)
  end
end
