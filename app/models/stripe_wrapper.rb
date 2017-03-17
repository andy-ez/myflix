module StripeWrapper
  class Charge
    attr_reader :response, :status
    def initialize(response, status)
      @response = response
      @status = status
    end

    def self.create(options={})
      StripeWrapper.set_api_key
      begin
        response = Stripe::Charge.create(
          :amount => options[:amount],
          :currency => "usd",
          :description => options[:description],
          :source => options[:source]
        )
        new(response, :success)
      rescue Stripe::CardError => e
        new(e.message, :error)
      end
    end

    def successful?
      status == :success
    end

    def error_message
      response
    end
  end

  class Customer
    attr_reader :customer, :status
    def initialize(customer, status)
      @customer = customer
      @status = status
    end

    def self.create(options={})
      StripeWrapper.set_api_key
      begin
        customer = Stripe::Customer.create(
          :source => options[:source],
          :email => options[:email],
          :plan => 'myflix_base',
          :description => options[:description]
        )
        new(customer, :valid)
      rescue Stripe::CardError => e
        new(e, :invalid)
      end
    end

    def self.retrieve(user)
      StripeWrapper.set_api_key
      begin
        Stripe::Customer.retrieve(user.customer_token)
      rescue Stripe::InvalidRequestError
        nil
      end
    end

    def valid?
      status == :valid
    end

    def error_message
      customer.message
    end
  end

  class Subscription
    def self.retrieve(user)
      customer = StripeWrapper::Customer.retrieve(user)
      if customer
        begin
          Stripe::Subscription.retrieve(customer.subscriptions.data[0].id)
        rescue Stripe::InvalidRequestError
          nil
        end
      end
    end

    def self.cancel_subscription(user)
      subscription = retrieve(user)
      subscription.delete if subscription 
    end
  end

  class Invoice
    def self.list(user, limit=10)
      customer = StripeWrapper::Customer.retrieve(user)
      Stripe::Invoice.list(customer: customer, limit: limit).try(:data)
    end
  end

  def self.set_api_key
    Stripe.api_key = ENV['stripe_api_key']
  end

end