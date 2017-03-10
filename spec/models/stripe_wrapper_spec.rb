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
end