class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user, :dependent => :destroy
  attr_accessible :body
  validates :question_id, :presence => true 
  validates :body, :presence => true
  default_scope :order => 'answers.created_at DESC'
end
