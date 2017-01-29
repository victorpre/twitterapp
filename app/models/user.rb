class User < ApplicationRecord
  TEMP_EMAIL_PREFIX = 'change@me'
  TEMP_EMAIL_REGEX = /\Achange@me/

  devise :database_authenticatable,
         :registerable, :trackable,
         :omniauthable,:validatable, :omniauth_providers => [:twitter]

  has_one :identity, dependent: :destroy

  def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    if user.nil?
      user = User.new(
        name: auth.info.name,
        profile_img_url: auth.info.image.gsub("_normal",""),
        email: "#{TEMP_EMAIL_PREFIX}#{auth.uid}#{auth.provider}.com",
        password: Devise.friendly_token[0,20]
      )
      user.save!
    end
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def has_complete_profile?
    info = ["name", "phone_number", "address", "city", "state", "country"]
    info.all?{|att| !self.attributes[att].empty? } and !self.has_default_email?
  end

  def has_default_email?
    if TEMP_EMAIL_REGEX.match(self.email)
      true
    else
      false
    end
  end

  def missing_attributes
    keys = self.attributes.select{|k,v| v.blank?}.keys
    keys.unshift("email") if self.has_default_email?
    keys
  end
end
