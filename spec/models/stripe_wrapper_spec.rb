require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      before { StripeWrapper.set_api_key }

      context "with a valid card" do
        it "should create a charge", :vcr do
            token = Stripe::Token.create(
                card: {
                  number: "42" * 8,
                  exp_month: "11",
                  exp_year: "2020",
                  cvc: "123"
                }
              ).id
          charge = StripeWrapper::Charge.create(amount: 90, description: "Test", source: token)
          expect(charge.response.amount).to eq(90)
        end
      end

      context "with an invalid card" do
        it "should not create a charge", :vcr do
          token = Stripe::Token.create(
              card: {
                number: "4000000000000119",
                exp_month: "11",
                exp_year: "2020",
                cvc: "123"
              }
            ).id
          charge = StripeWrapper::Charge.create(amount: 90, description: "Test", source: token)
          expect(charge.error_message).to eq("An error occurred while processing your card. Try again in a little bit.")
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      before { StripeWrapper.set_api_key }

      context "with valid card", :vcr do
        let(:token) do 
          Stripe::Token.create(
              card: {
                number: "42" * 8,
                exp_month: "11",
                exp_year: "2020",
                cvc: "123"
              }
            ).id
        end
        let(:response) { StripeWrapper::Customer.create(email: "joe@example.com", source: token) }

        it "creates a customer object with the correct email" do
          expect(response.customer.object).to eq('customer')
          expect(response.customer.email).to eq("joe@example.com")
        end

        it "returns a valid customer" do
          expect(response).to be_valid
        end

        it 'creates a subscription for the customer for the myflix_base plan' do
          expect(response.customer.subscriptions.count).to eq(1)
          expect(response.customer.subscriptions.first.plan.id).to eq("myflix_base")
        end

        it "returns the customer id" do
          expect(response.customer.id).to be_present
        end
      end

      context "with a declined card" do
        it "does not create a customer", :vcr do
          invalid_token = Stripe::Token.create(
              card: {
                number: "4000000000000119",
                exp_month: "11",
                exp_year: "2020",
                cvc: "123"
              }
            ).id
          response = StripeWrapper::Customer.create(email: "joe@example.com", source: invalid_token)
          expect(response.error_message).to eq("An error occurred while processing your card. Try again in a little bit.")
          expect(response).not_to be_valid
        end
      end
    end
  end

  describe StripeWrapper::Subscription do
    describe ".retrieve" do
      context "with a valid subscription", :vcr do
        let(:token) do 
          Stripe::Token.create(
              card: {
                number: "42" * 8,
                exp_month: "11",
                exp_year: "2020",
                cvc: "123"
              }
            ).id
        end
        let(:response) { StripeWrapper::Customer.create(email: "alice@example.com", source: token) }
        let(:alice) { Fabricate(:user, email: "alice@example.com", customer_token: response.customer.id) }

        it "returns a valid subscription" do
          subscription = StripeWrapper::Subscription.retrieve(alice)
          expect(subscription.object).to eq("subscription")
          expect(subscription.id).to eq(response.customer.subscriptions.data[0].id)
        end
      end

      context "with no subscription", :vcr do
        it "returns nil" do
          alice = Fabricate(:user)
          expect(StripeWrapper::Subscription.retrieve(alice)).to be nil
        end
      end
    end

    describe ".cancel_subscription" do
      context "with a valid subscription", :vcr do
        let(:token) do 
          Stripe::Token.create(
              card: {
                number: "42" * 8,
                exp_month: "11",
                exp_year: "2020",
                cvc: "123"
              }
            ).id
        end
        let(:response) { StripeWrapper::Customer.create(email: "alice@example.com", source: token) }
        let(:alice) { Fabricate(:user, email: "alice@example.com", customer_token: response.customer.id) }

        it "cancels the subscription" do
          StripeWrapper::Subscription.cancel_subscription(alice)
          customer = StripeWrapper::Customer.retrieve(alice)
          expect(customer.subscriptions.data.count).to eq(0)
        end
      end
    end
  end

  describe StripeWrapper::Invoice do
    describe ".list", :vcr do
      let(:token) do 
        Stripe::Token.create(
            card: {
              number: "42" * 8,
              exp_month: "11",
              exp_year: "2020",
              cvc: "123"
            }
          ).id
      end
      let(:response) { StripeWrapper::Customer.create(email: "alice@example.com", source: token) }
      let(:alice) { Fabricate(:user, email: "alice@example.com", customer_token: response.customer.id) }
      it "returns an array of invoice objects" do
        invoices = StripeWrapper::Invoice.list(alice)
        expect(invoices.first.object).to eq("invoice")
      end

      it "returns an invoice for the right user" do
        invoices = StripeWrapper::Invoice.list(alice)
        expect(invoices.first.customer).to eq(alice.customer_token)
      end
    end
  end
end