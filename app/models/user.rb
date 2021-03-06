class User < ApplicationRecord
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :event_users
  has_many :events, through: :event_users
  has_many :categories, through: :events
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :trackable,
        :validatable, :omniauthable, omniauth_providers: %i[facebook]
  accepts_nested_attributes_for :events, :friendships

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.all_except(friends)
  where.not(id: friends)
  end
end
