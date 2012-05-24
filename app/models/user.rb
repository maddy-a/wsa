# == Schema Information
# Schema version: 20100829021049
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable and :activatable
  

  # Setup accessible (or protected) attributes for your model
  has_many :authentications
  attr_accessor   :password
  attr_accessible :name, :email, :password, :password_confirmation, :country, :department, :gender, :level, :remember_me
  
  has_many :microposts,    :dependent => :destroy
  has_many :relationships, :dependent => :destroy,
                           :foreign_key => "follower_id"
  has_many :reverse_relationships, :dependent => :destroy,
                                   :foreign_key => "followed_id",
                                   :class_name => "Relationship"
  has_many :following, :through => :relationships, :source => :followed
  has_many :followers, :through => :reverse_relationships,
                       :source  => :follower
  
  has_many :questions, :dependent => :destroy
  has_many :answers, :dependent => :destroy
  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
 
  validates :name,  :presence => true,
                    :length   => { :maximum => 50 }
  validates :email, :presence   => true,
                    :format     => { :with => email_regex },
                    :uniqueness => true
  validates :password, :presence => true,
                       :confirmation => true,
                       :length => { :within => 6..40 }
  
  validates_presence_of :country

  validates_inclusion_of :gender, :in => [:male, :female]
  
  validates_inclusion_of :level, :in => [:undergrad, :exchange, :masters, :PhD, :scholar, :other]
  
  validates_inclusion_of :department, :in => [:engineering, :arts, :maths, :architecture, :education, :medical, :pharmacy, :physics]
  
  before_save :encrypt_password
  
  def has_password?(submitted_password)
    encrypted_password == encrypt(submitted_password)
  end
  
  def enum_of_other_fields
     read_attribute(:gender, :level, :department).to_sym
  end

  def enum_of_other_fields= (value)
     write_attribute(:gender, :level, :department, value.to_s)
  end
  
  def feed
    Micropost.from_users_followed_by(self)
  end
  
  def following?(followed)
    relationships.find_by_followed_id(followed)
  end
  
  def follow!(followed)
    relationships.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    relationships.find_by_followed_id(followed).destroy
  end

  class << self
    def authenticate(email, submitted_password)
      user = find_by_email(email)
      (user && user.has_password?(submitted_password)) ? user : nil
    end
    
    def authenticate_with_salt(id, cookie_salt)
      user = find_by_id(id)
      (user && user.salt == cookie_salt) ? user : nil
    end
  end
  
  
  
  private
  
    def encrypt_password
      self.salt = make_salt unless has_password?(password)
      self.encrypted_password = encrypt(password)
    end
  
    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end
    
    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end
    
    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end
end
