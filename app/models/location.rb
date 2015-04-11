class Location < ActiveRecord::Base

  has_many :facts, dependent: :nullify

end