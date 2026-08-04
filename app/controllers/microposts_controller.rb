class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    attach_image

    if @micropost.save
      create_success
    else
      create_fail
    end
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t("flash.success.micropost_delete")
    else
      flash[:danger] = t("flash.danger.delete_fail")
    end
    redirect_to root_url(locale: I18n.locale)
  end

  private
  def micropost_params
    params.require(:micropost).permit :content, :image
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    return if @micropost

    flash[:danger] = t("flash.danger.micropost_invalid")
    redirect_to root_url(locale: I18n.locale)
  end

  def attach_image
    @micropost.image.attach params.dig(:micropost, :image)
  end

  def create_success
    flash[:success] = t("flash.success.micropost")
    redirect_to root_url(locale: I18n.locale)
  end

  def create_fail
    @pagy, @feed_items = pagy(current_user.feed, items: Settings.pagy.items)
    render "static_pages/home", status: :unprocessable_entity
  end
end
