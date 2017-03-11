require 'spec_helper'

describe "Create payment on successful charge", :vcr do
  let(:event_data) do
    {
      "id"=> "evt_19wEmuEI3UfzsZ2pSvJwmVGA",
      "object"=> "event",
      "api_version"=> "2017-02-14",
      "created"=> 1489256276,
      "data"=> {
        "object"=> {
          "id"=> "ch_19wEmuEI3UfzsZ2pKMEeGswe",
          "object"=> "charge",
          "amount"=> 999,
          "amount_refunded"=> 0,
          "application"=> nil,
          "application_fee"=> nil,
          "balance_transaction"=> "txn_19wEmuEI3UfzsZ2pqz6N9y2x",
          "captured"=> true,
          "created"=> 1489256276,
          "currency"=> "usd",
          "customer"=> "cus_AGmL57N4LhSF46",
          "description"=> nil,
          "destination"=> nil,
          "dispute"=> nil,
          "failure_code"=> nil,
          "failure_message"=> nil,
          "fraud_details"=> {
          },
          "invoice"=> "in_19wEmuEI3UfzsZ2pVuzAwmkk",
          "livemode"=> false,
          "metadata"=> {
          },
          "on_behalf_of"=> nil,
          "order"=> nil,
          "outcome"=> {
            "network_status"=> "approved_by_network",
            "reason"=> nil,
            "risk_level"=> "normal",
            "seller_message"=> "Payment complete.",
            "type"=> "authorized"
          },
          "paid"=> true,
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "refunded"=> false,
          "refunds"=> {
            "object"=> "list",
            "data"=> [

            ],
            "has_more"=> false,
            "total_count"=> 0,
            "url"=> "/v1/charges/ch_19wEmuEI3UfzsZ2pKMEeGswe/refunds"
          },
          "review"=> nil,
          "shipping"=> nil,
          "source"=> {
            "id"=> "card_19wEmsEI3UfzsZ2pOdN21jKc",
            "object"=> "card",
            "address_city"=> nil,
            "address_country"=> nil,
            "address_line1"=> nil,
            "address_line1_check"=> nil,
            "address_line2"=> nil,
            "address_state"=> nil,
            "address_zip"=> "90210",
            "address_zip_check"=> "pass",
            "brand"=> "Visa",
            "country"=> "US",
            "customer"=> "cus_AGmL57N4LhSF46",
            "cvc_check"=> "pass",
            "dynamic_last4"=> nil,
            "exp_month"=> 11,
            "exp_year"=> 2020,
            "fingerprint"=> "Vn8ads1tKXuG32cT",
            "funding"=> "credit",
            "last4"=> "4242",
            "metadata"=> {
            },
            "name"=> nil,
            "tokenization_method"=> nil
          },
          "source_transfer"=> nil,
          "statement_descriptor"=> "Myflix Video Service",
          "status"=> "succeeded",
          "transfer_group"=> nil
        }
      },
      "livemode"=> false,
      "pending_webhooks"=> 1,
      "request"=> "req_AGmL9oocCkHeN7",
      "type"=> "charge.succeeded"
    }
  end
  it "creates a payment with the webhook from stripe for charge succeeded", :vcr do
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user" do
    alice = Fabricate(:user, customer_token: 'cus_AGmL57N4LhSF46')
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end

  it "creates the payment with the amount" do
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq(999)
  end

  it "creates a payment with the correct reference id" do
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq("ch_19wEmuEI3UfzsZ2pKMEeGswe")
  end
end