require 'spec_helper'

describe "Deactivate user on failed charge", :vcr do
  let(:event_data) do
    {
      "id"=> "evt_19wI93EI3UfzsZ2pGC4MzHkb",
      "object"=> "event",
      "api_version"=> "2017-02-14",
      "created"=> 1489269181,
      "data"=> {
        "object"=> {
          "id"=> "ch_19wI93EI3UfzsZ2pFl7bnoXj",
          "object"=> "charge",
          "amount"=> 999,
          "amount_refunded"=> 0,
          "application"=> nil,
          "application_fee"=> nil,
          "balance_transaction"=> nil,
          "captured"=> false,
          "created"=> 1489269181,
          "currency"=> "usd",
          "customer"=> "cus_AGpHKE2EQKKSGG",
          "description"=> "Myflix",
          "destination"=> nil,
          "dispute"=> nil,
          "failure_code"=> "card_declined",
          "failure_message"=> "Your card was declined.",
          "fraud_details"=> {},
          "invoice"=> nil,
          "livemode"=> false,
          "metadata"=> {},
          "on_behalf_of"=> nil,
          "order"=> nil,
          "outcome"=> {
            "network_status"=> "declined_by_network",
            "reason"=> "generic_decline",
            "risk_level"=> "normal",
            "seller_message"=> "The bank did not return any further details with this decline.",
            "type"=> "issuer_declined"
          },
          "paid"=> false,
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "refunded"=> false,
          "refunds"=> {
            "object"=> "list",
            "data"=> [],
            "has_more"=> false,
            "total_count"=> 0,
            "url"=> "/v1/charges/ch_19wI93EI3UfzsZ2pFl7bnoXj/refunds"
          },
          "review"=> nil,
          "shipping"=> nil,
          "source"=> {
            "id"=> "card_19wI8DEI3UfzsZ2pcz2oSxgP",
            "object"=> "card",
            "address_city"=> nil,
            "address_country"=> nil,
            "address_line1"=> nil,
            "address_line1_check"=> nil,
            "address_line2"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_zip_check"=> nil,
            "brand"=> "Visa",
            "country"=> "US",
            "customer"=> "cus_AGpHKE2EQKKSGG",
            "cvc_check"=> "pass",
            "dynamic_last4"=> nil,
            "exp_month"=> 3,
            "exp_year"=> 2019,
            "fingerprint"=> "vRvDOFzQI0L5Xg2d",
            "funding"=> "credit",
            "last4"=> "0341",
            "metadata"=> {},
            "name"=> nil,
            "tokenization_method"=> nil
          },
          "source_transfer"=> nil,
          "statement_descriptor"=> "Myflix",
          "status"=> "failed",
          "transfer_group"=> nil
        }
      },
      "livemode"=> false,
      "pending_webhooks"=> 1,
      "request"=> "req_AGpo1P56HX9BK7",
      "type"=> "charge.failed"
    }
  end
  
  it "should deactivate a user with the webhook data from stripe" do
    alice = Fabricate(:user, customer_token: "cus_AGpHKE2EQKKSGG")
    post "/stripe_events", event_data
    expect(User.first).not_to be_active
  end
end 