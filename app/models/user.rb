class User < ApplicationRecord
  extend FriendlyId
  friendly_id :generate_friendly_id, :use => [:slugged, :finders]
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable,:rememberable,
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :lockable, :omniauthable, :omniauth_providers => [:facebook]
  
  has_many :stories, dependent: :destroy 
  has_many :stories_posted, :class_name => 'Story', :foreign_key => 'poster_id', dependent: :destroy 
  has_many :bookmarks, dependent: :destroy
  has_many :followings, dependent: :destroy #@user.followings yields a collection of Following where user_id = @user.id
  has_many :following_users, class_name: "Following", foreign_key: :follower_id, dependent: :destroy #@user.following_users yields a collection of Following where follower_id = @user.id
  has_many :followers, through: :followings, class_name: "User", dependent: :destroy #@user.followers yields a collection of other Users who follow @user
  has_many :reactions, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscription_preferences, dependent: :destroy
  
  cattr_accessor :form_steps do
    %w(basic_details)
  end
  
  attr_accessor :form_step
  
  validates :first_name, presence: true, unless: :inactive?
  validates :last_name, presence: true, unless: :inactive?
  validates :birthday, presence: true, if: :active?
  validates :gender, presence: true, if: :active?
  validates_with AttachmentSizeValidator, attributes: :image, less_than: 8.megabytes
  
  scope :author_deactive, -> { where.not(deactivated_at: nil) }
  
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
  
  def display_name
    f_name = self.first_name.titleize.gsub(/\b\w/) { |w| w.upcase }
    l_initial = self.last_name.titleize.first
    "#{f_name} #{l_initial}."
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
  
  def smallsquareimage
#    "http://graph.facebook.com/#{self.uid}/picture?type=square&type=large"
    "https://graph.facebook.com/#{self.uid}/picture?type=square&width=80&height=80"
  end
  
  has_attached_file :image, styles: {
    thumb: '100x100>',
    square: '200x200#',
    medium: '300x300>'
    }
  
  validates_attachment :image, :content_type => { content_type: ["image/jpeg", "image/jpg", "image/gif", "image/png"] }, :size => { in: 0..8.megabytes }
  
  def self.valid_user?(resource)
    resource && resource.kind_of?(User) && resource.valid?
  end

  def log_devise_action(new_action)
    if new_action == "sign_in"
      UserSessionLog.create!(user_id: id, user_ip: current_sign_in_ip, sign_in:  DateTime.now)
    elsif new_action == "sign_out"
      UserSessionLog.where(user_id: id, user_ip: current_sign_in_ip).last.update(sign_out: DateTime.now)
    end
  end
  
  private
  
  def self.process_uri(uri)
    avatar_url = URI.parse(uri)
    avatar_url.scheme = 'https'
    avatar_url.to_s
  end
  
  def should_generate_new_friendly_id?
    first_name_changed? || last_name_changed? || super
  end
  
  def generate_friendly_id
    [
      [:first_name, :last_name],
      [:first_name, :last_name, :id]
    ]
  end
end