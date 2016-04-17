class PakketHub::TravelPlan < PakketHub::BaseModel

  belongs_to :destination, class_name: 'Location'
  belongs_to :location

  accepts_nested_attributes_for :location, :destination

end