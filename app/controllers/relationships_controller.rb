class RelationshipsController < ApplicationController
  before_action :logged_in_user
  before_action :load_user, only: :create
  before_action :load_relationship, only: :destroy

  def create
    current_user.follow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.turbo_stream
    end
    redirect_to user_path(@user, locale: I18n.locale)
  end

  def destroy
    @user = @relationship.followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html{redirect_to @user}
      format.turbo_stream
    end
    redirect_to user_path(@user, locale: I18n.locale)
  end

  private

  def load_user
    @user = User.find_by id: params[:followed_id]

    return if @user

    flash[:danger] = t("flash.danger.user_not_found")
    redirect_to root_path(locale: I18n.locale)
  end

  def load_relationship
    @relationship = Relationship.find_by id:
      params[:id]
    # handle when relationship is nil
    return if @relationship

    flash[:danger] = t("flash.danger.relationship_not_found")
    redirect_to root_path(locale: I18n.locale)
  end
end
