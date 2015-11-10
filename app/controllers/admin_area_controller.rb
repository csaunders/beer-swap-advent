class AdminAreaController < ApplicationController
  before_action :require_admin

  private
  def require_admin
    return if administrator?
    flash[:error] = "Unauthorized"
    redirect_to root_path
  end
end
