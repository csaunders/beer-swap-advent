module SubmissionsHelper
  def pretty_day(datetime)
    datetime.strftime("%e %b")
  end
end
