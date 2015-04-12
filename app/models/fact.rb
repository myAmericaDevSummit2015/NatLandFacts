class Fact < ActiveRecord::Base

  acts_as_list

  enum fact_type: { fun_fact: 1, movie: 2, history: 3 }
  
  belongs_to :location

  validates :title, presence: true, uniqueness: true
  validates :fact_type, presence: true
  validates :state_name, presence: true, inclusion: {in: Location::STATES.keys}
  validates :rec_area_id, presence: true
  validates :location_title, presence: true

  before_validation :sanitize_pic_url

  scope :pending, -> { where validated_at: nil }
  scope :validated, -> { where.not validated_at: nil }
  scope :most_recent, -> { order created_at: :desc }


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

  private

  # add "http://" to the picture url if not already
  def sanitize_pic_url
    if pic_url.present? && (pic_url =~ %r{\Ahttps?://}).nil?
      self.pic_url = "http://#{pic_url}"
    end
  end

end