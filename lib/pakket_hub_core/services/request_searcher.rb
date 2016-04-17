class PakketHub::RequestSearcher < PakketHub::BaseService
  attr_accessor :travel_plan

  def initialize(_travel_plan)
    @travel_plan = _travel_plan
  end

  def self.search(travel_plan)
    searcher = new(travel_plan)
    searcher.search
  end

  def search
    candidates = relation.to_a
    PakketHub::EagerLoader.load(candidates, :location)
    candidates.select! do |c|
      d = PakketHub.distance(c.latitude, c.longitude, lat, lng)
      candidate.distance = d
      d <= radius + c.radius
    end
    candidates
  end

  def lat
    travel_plan.destination.latitude
  end

  def lng
    travel_plan.destination.longitude
  end

  def radius
    travel_plan.radius
  end

  def equation_sql_part
    %{3956.15898291568 * 2 * ASIN(
    SQRT( POWER(SIN((? - abs(locations.latitude)) * pi()/180 / 2), 2) 
    + COS(? * pi()/180 ) * COS(abs(locations.latitude) * pi()/180)  
    * POWER(SIN((? - locations.longitude) * pi()/180 / 2), 2) )) <= ? + requests.radius
      }
  end

  def relation
    Request.where("size_code <= ?", travel_plan.size_code).
      joins(:location).
      where("requests.end_date IS NULL OR requests.end_date >= ?", travel_plan.start_date).
      where("requests.end_time IS NULL OR requests.end_time > ?", travel_plan.start_time).
      where("requests.start_date <= ?", travel_plan.end_date).
      where("requests.start_time < ?", travel_plan.end_time).
      where(equation_sql_part, lat, lng, lng, radius)
  end

end