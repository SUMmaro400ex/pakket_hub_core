class PakketHub::Exchange < PakketHub::BaseModel

  def self.create_and_pull_funds(request, travel_plan)
    transaction do
      exchange = Exchange.create
      exchange.request_id = request.id
      exchange.courier_id = travel_plan.courier_id
      pull_funds = PullFunds.new(exchange)
      pull_funds.pull_funds
      push_funds = PushFunds.new(exchange)
      push_funds.push_funds
    end
  end

  def disperse_funds
    pull_funds = PullFunds.new(self)
    pull_funds.pull_funds
    push_funds = PushFunds.new(self)
    push_funds.push_funds
    self.complete = true
  end

end
