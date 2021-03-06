class Review < ActiveRecord::Base
  attr_accessible :junior_consultant_id, :review_type, :review_date, :feedback_deadline, :send_link_date

  belongs_to :junior_consultant

  validates :review_type, :presence => true, :inclusion => { :in => %w(6-Month 12-Month 18-Month 24-Month) }
  validates :junior_consultant_id, :presence => true
  validates :junior_consultant_id, :uniqueness => {:scope => [:review_type]}

  has_many :feedbacks, :dependent => :destroy
  has_many :self_assessments, :dependent => :destroy


  def to_s
    "#{junior_consultant} - #{review_type}"
  end
end
