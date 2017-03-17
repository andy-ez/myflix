class StripeCustomerDecorator
  attr_reader :stripe_customer
  def initialize(stripe_customer)
    @stripe_customer = stripe_customer
  end

  def id
    stripe_customer.id
  end

  def subscription_id
    stripe_customer.subscriptions.data[0].id
  end

  def plan_name
    stripe_customer.subscriptions.data[0].plan.name
  end

  def plan_amount
    "$#{stripe_customer.subscriptions.data[0].plan.amount / 100.0}"
  end

  def plan_interval
    stripe_customer.subscriptions.data[0].plan.interval
  end

  def plan_cost
    "#{plan_amount} per #{plan_interval}"
  end

  def next_payment_date
    if plan_active?
      date = Date.strptime(stripe_customer.subscriptions.data[0].current_period_end.to_s, '%s') 
      date.strftime("%m/%d/%y")
    end
  end

  def plan_active?
    stripe_customer.subscriptions.data[0].status == 'active'
  end

  def any_subscriptions?
    stripe_customer.subscriptions.data.count > 0
  end
end