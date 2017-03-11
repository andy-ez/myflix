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
end