class Admin::PaymentsController < AdminController
  def index
    @payments = Payment.limit(100)
  end
end