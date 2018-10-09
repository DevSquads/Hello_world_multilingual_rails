class ApplicationController < ActionController::Base
  before_action :set_locale
  skip_before_action :verify_authenticity_token

  # Sets the current locale for a request
  # It can be set in three ways:
  # 1- If the request is through a browser with a locale suffix
  # 2- If the request is through the api with a LANG headers (as requested)
  # 3- The default locale
  def set_locale
    I18n.locale = params[:locale] || request.headers['LANG'] || I18n.default_locale
  end
end
