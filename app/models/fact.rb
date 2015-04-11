class Fact < ActiveRecord::Base

  acts_as_list
  
  belongs_to :location

  validates :title, presence: true, uniqueness: true
  # validates :location, presence: true

  delegate :title, to: :location, prefix: true, allow_nil: true

end