class Fact < ActiveRecord::Base

  acts_as_list
  
  belongs_to :location

  validates :title, presence: true, uniqueness: true
  # validates :location, presence: true

  scope :pending, -> { where validated_at: nil }
  scope :validated, -> { where.not validated_at: nil }
  scope :most_recent, -> { order created_at: :desc }

  delegate :title, to: :location, prefix: true, allow_nil: true

  def pending?
    validated_at.blank?
  end

end