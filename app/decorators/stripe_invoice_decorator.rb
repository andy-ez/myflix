class StripeInvoiceDecorator
  attr_reader :invoice
  def initialize(invoice)
    @invoice = invoice
  end

  def date
    date = Date.strptime(invoice.date.to_s, '%s').strftime("%m/%d/%y")
  end

  def service_duration
    start = Date.strptime(invoice.period_start.to_s, '%s').strftime("%m/%d/%Y")
    ending = Date.strptime(invoice.period_end.to_s, '%s').strftime("%m/%d/%Y")
    "#{start} - #{ending}"
  end

  def total
    "$#{invoice.total / 100.0}"
  end
end