class SubmissionsController < ApplicationController
  before_action :require_user, only: [:update, :edit, :your_submission]
  before_action :require_owner, only: [:edit, :update]
  before_action :require_submission, only: :your_submission
  before_action :require_region, only: [:index]

  helper_method :submissions, :submission

  def index
  end

  def show
  end

  def update
  end

  def edit
  end

  def your_submission
    redirect_to edit_submission_path(users_submission)
  end

  private
  def users_submission
    @submission ||= current_user.submission
  end

  def submissions
    @submissions ||= params[:region] == 'west' ? Submission.west : Submission.east
  end

  def submission
    Submission.visible.find(params[:id])
  end

  def require_user
    return if user_signed_in?
    flash[:error] = "You must be signed in to do that"
    redirect_to root_path
  end

  def require_owner
    return if params[:id] == users_submission.id
    flash[:error] = "You do not have permission to do that"
    redirect_to root_path
  end

  def require_submission
    return if users_submission
    flash[:error] = "You do not appear to have a submission"
    redirect_to root_path
  end

  def require_region
    return if Submission::REGIONS.include?(params[:region])
    flash[:error] = "'#{params[:region]}' is not a valid region"
    redirect_to root_path
  end
end
