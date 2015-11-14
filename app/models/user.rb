class User < ActiveRecord::Base
  has_one :submission, dependent: :destroy
  has_many :feedbacks, dependent: :destroy

  def self.create_with_omniauth(auth)
    User.transaction do
      User.where(uid: auth['uid']).first_or_initialize.tap do |user|
        user.provider = auth['provider']
        user.uid = auth['uid']
        if auth['info']
          user.profile_pic = auth['info']['image'] || ""
          user.name = auth['info']['name'] || ""
        end
        user.save!
        Submission.create!(user: user)
      end
    end
  end

end
