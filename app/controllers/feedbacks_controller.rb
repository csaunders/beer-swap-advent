class FeedbacksController < ApplicationController
  def create
    feedback.update_attributes(feedback_params)
    redirect_to submission_path(submission)
  end
  alias update create

  private
  def submission
    @submission ||= Submission.find(params[:submission_id])
  end

  def feedback
    @feedback ||= Feedback.where(submission: submission, user: current_user).first_or_initialize
  end

  def feedback_params
    params.require(:feedback).permit(:body)
  end
end
