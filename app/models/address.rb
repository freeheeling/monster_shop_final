class Address < ApplicationRecord
  belongs_to :user
  has_many :orders

  validates_presence_of :address, :city, :state, :zip, :alias

  validates_length_of :zip, is: 5
  validates_numericality_of :zip
end
