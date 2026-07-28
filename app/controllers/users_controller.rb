class UsersController < ApplicationController
  def show
    @user = User.find_by id: params[:id]
    return if @user

    redirect_to root_path(locale: I18n.locale)

    flash[:danger] = t("flash.danger.user_not_found")
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t("flash.success.create")
      redirect_to user_path(@user, locale: I18n.locale)
    else
      render :new
    end
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
end
