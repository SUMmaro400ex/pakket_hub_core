class PakketHub::Request < PakketHub::BaseModel
  attr_accessor :distance

  belongs_to :location

  accepts_nested_attributes_for :location
  delegate :latitude, :longitude, to: :location
end