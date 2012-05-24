class Question < ActiveRecord::Base
  has_many :answers
  attr_accessible :title, :body
  belongs_to :user, :dependent => :destroy
  
  validates :title, :presence => true 
  validates :body, :presence => true
  validates :user_id, :presence => true 
  default_scope :order => 'questions.created_at DESC'
end
