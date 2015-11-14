class SubmissionsController < ApplicationController
  before_action :require_user, only: [:update, :edit, :your_submission]
  before_action :require_owner, only: [:edit, :update]
  before_action :require_submission, only: :your_submission
  before_action :require_region, only: [:index]

  helper_method :submissions, :submission, :feedbacks, :user_feedback

  def index
  end

  def show
  end

  def update
    users_submission.update_attributes(submission_params)
    users_submission.beer_xml = beer_xml_file if beer_xml_file
    users_submission.save
    flash[:notice] = "#{users_submission.name} has been updated"
    redirect_to submission_path(users_submission)
  end

  def edit
  end

  def your_submission
    redirect_to edit_submission_path(users_submission)
  end

  private
  def users_submission
    @users_submission ||= current_user.submission if user_signed_in?
  end

  def submissions
    @submissions ||= begin
      submissions = params[:region] == 'west' ? Submission.west : Submission.east
      submissions.includes(:user)
    end
  end

  def feedbacks
    return unless submission == users_submission
    @feedbacks ||= submission.feedbacks.includes(:user)
  end

  def user_feedback
    return unless user_signed_in?
    return if submission == users_submission
    @user_feedback ||= current_user.feedbacks.where(submission_id: submission.id).first_or_initialize
  end

  def submission
    @submission ||= if users_submission && users_submission.id == params[:id].to_i
      users_submission
    else
      Submission.visible.find(params[:id])
    end
  end

  def require_user
    return if user_signed_in?
    flash[:error] = "You must be signed in to do that"
    redirect_to root_path
  end

  def require_owner
    return if submission == users_submission
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

  def submission_params
    params.require(:submission).permit(:region, :name, :ibu, :abv, :srm, :recipe)
  end

  def beer_xml_file
    params.require(:submission).permit(:beer_xml)[:beer_xml]
  end
end
