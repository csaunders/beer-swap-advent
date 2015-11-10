class Admin::SubmissionsController < AdminAreaController
  helper_method :sectioned_regions

  def update
    update_submissions
    redirect_to admin_dashboard_path
  end

  private
  def sectioned_regions
    @sectioned_regions ||= {
      west: Submission.west.includes(:user),
      east: Submission.east.includes(:user)
    }
  end

  def update_submissions
    submission_dates.each do |id, day|
      Submission.update(id, day: day)
    end
  end

  def submission_dates
    params.fetch(:day)
  end
end
