class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]
  
  has_many :stories  
  has_many :story_likes
  has_many :bookmarks
  has_many :followings
  has_many :followers, through: :followings, class_name: "User"
  
  cattr_accessor :form_steps do
    %w(basic_details)
  end
  
  attr_accessor :form_step
  
  validates :first_name, presence: true, unless: :inactive?
  validates :last_name, presence: true, unless: :inactive?
  validates :birthday, presence: true, if: :active?
  validates :gender, presence: true, if: :active?
  validates_with AttachmentSizeValidator, attributes: :image, less_than: 8.megabytes
  
  def active?
    #active is set by registration_steps 
    #controller; active+db is set by 
    #registrations_controller
    status == 'active'
  end
  
  def inactive?
    status == nil
  end
  
  def full_name
    f_name = self.first_name.titleize.gsub(/\b\w/) { |w| w.upcase }
    l_name = self.last_name.titleize.gsub(/\b\w/) { |w| w.upcase }
    "#{f_name} #{l_name}"
  end
  
  def follows?(follow)
    Following.where(follower_id: self.id).where(user_id: follow.id).any?
  end
  
  def self.from_omniauth(auth)
#    binding.pry
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
      user.fbimage = auth.info.image
#      user.image = process_uri(auth.info.image)
      user.age_range = auth.extra.raw_info.age_range
      user.password = Devise.friendly_token[0,20]
      user.gender = auth.extra.raw_info.gender
    end
  end
  
  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end
  
  def self.find_for_facebook_oauth(auth)
    #if not a new record
    user = User.where("(uid = ? AND provider = 'facebook') OR lower(email) = ?", auth.uid, auth.info.email).first

    user.provider = auth.provider
    user.uid = auth.uid
    user.fbimage = auth.info.image
#    user.image = process_uri(auth.info.image)
    user.age_range = auth.extra.raw_info.age_range

    user.save
    user
  end
  
  def largesquareimage
#    "http://graph.facebook.com/#{self.uid}/picture?type=square&type=large"
    "https://graph.facebook.com/#{self.uid}/picture?type=square&width=200&height=200"
  end
  
  has_attached_file :image, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
    }
  
  validates_attachment :image, :content_type => { content_type: ["image/jpeg", "image/jpg", "image/gif", "image/png"] }, :size => { in: 0..8.megabytes }
  
  private
  
  def self.process_uri(uri)
    avatar_url = URI.parse(uri)
    avatar_url.scheme = 'https'
    avatar_url.to_s
  end
end