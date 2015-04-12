class Fact < ActiveRecord::Base

  acts_as_list

  enum fact_type: { fun_fact: 1, movie: 2, history: 3 }
  
  belongs_to :location

  validates :title, presence: true, uniqueness: true
  validates :fact_type, presence: true
  # validates :rec_area_id, presence: true
  # validates :location_title, presence: true
  # validates :lat, presence: true
  # validates :lng, presence: true

  scope :pending, -> { where validated_at: nil }
  scope :validated, -> { where.not validated_at: nil }
  scope :most_recent, -> { order created_at: :desc }

  delegate :title, to: :location, prefix: true, allow_nil: true


  def self.types_for_select(hash = {})
    fact_types.keys.each {|k| hash[I18n.t("activerecord.attributes.fact.fact_types.#{k}")] = k }
    hash
  end

  def pending?
    validated_at.blank?
  end

  def humanized_type
    I18n.t("activerecord.attributes.fact.fact_types.#{self.fact_type}")
  end

end