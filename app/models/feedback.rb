class Feedback < ActiveRecord::Base
  belongs_to :user
  belongs_to :submission
  validates :body, presence: true
end
