class PakketHub::Exchange < PakketHub::BaseModel

  def create_and_pull_funds(request, travel_plan)
    transaction do
      exchange = Exchange.create
      exchange.request_id = request.id
      exchange.courier_id = travel_plan.courier_id
      pull_funds = PullFunds.new(exchange)
    end
  end
  
end
