class PakketHub::TravelPlanSearcher < PakketHub::BaseService

  attr_reader :request

  def initialize(_request)
    @request = _request
  end

  def self.search(request)
    searcher = new(request)
    searcher.search
  end

  def search
    candidates = relation.to_a
    PakketHub::EagerLoader.load(candidates, :destination)
    candidates.select! do |c|
      d = PakketHub.distance(c.destination.latitude, c.destination.longitude, lat, lng)
      candidate.distance = d
      d <= radius + c.radius
    end
    candidates
  end

  def lat
    request.latitude
  end

  def lng
    request.longitude
  end

  def radius
    request.radius
  end

  def equation_sql_part
    %{3956.15898291568 * 2 * ASIN(
    SQRT( POWER(SIN((? - abs(locations.latitude)) * pi()/180 / 2), 2) 
    + COS(? * pi()/180 ) * COS(abs(locations.latitude) * pi()/180)  
    * POWER(SIN((? - locations.longitude) * pi()/180 / 2), 2) )) <= ? + travel_plans.radius
      }
  end

  def relation
    TravelPlan.where("travel_plans.size_code <= ?", request.size_code).
      joins(:destination).
      where("travel_plans.end_date IS NULL OR travel_plans.end_date >= ?", request.start_date).
      where("travel_plans.start_date <= ?", request.end_date).
      where(equation_sql_part, lat, lng, lng, radius)
  end

end