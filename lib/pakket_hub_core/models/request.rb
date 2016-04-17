class PakketHub::Request < PakketHub::BaseModel
  attr_accessor :distance

  belongs_to :location

  delegate :latitude, :longitude, to: :location
end