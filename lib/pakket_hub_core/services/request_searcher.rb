class PakketHub::RequestSearcher < PakketHub::BaseService

  def initialize(_travel_plan)
    @travel_plan = _travel_plan
  end

  def self.search(travel_plan)
    searcher = new(travel_plan)
    searcher.search
  end

  def search

  end

  def latitude
    travel_plan.latitude
  end

  def longitude
    travel_plan.longitude
  end

  def radius
    travel_plan.radius
  end

  def start_date
    travel_plan.start_date
  end

  def end_date
    travel_plan.end_date
  end

end