class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :set_locale

  include SessionsHelper
  include Pagy::Backend

  private

  def logged_in_user
    return if logged_in?

    flash[:danger] = t("flash.danger.pls_login")
    store_location
    redirect_to login_url(locale: I18n.locale)
  end

  def admin_user
    redirect_to root_path(locale: I18n.locale) unless current_user&.admin?
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
end
