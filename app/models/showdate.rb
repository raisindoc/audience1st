class Showdate < ActiveRecord::Base
  
  belongs_to :show
  has_many :vouchers
  has_many :valid_vouchers, :dependent => :destroy
  has_many :vouchertypes, :through => :valid_vouchers
  
  validates_numericality_of :max_sales
  validates_associated :show

  include Comparable
  def <=>(other_showdate)
    other_showdate ? thedate <=> other_showdate.thedate : 1
  end

  def sales_by_type(vouchertype_id)
    return Voucher.count(:conditions => ['showdate_id = ? AND vouchertype_id = ?', self.id, vouchertype_id])
  end

  def revenue_by_type(vouchertype_id)
    self.vouchers.find_by_id(vouchertype_id).inject(0) {|sum,v| sum + v.price}
  end

  def revenue
    self.vouchers.inject(0) {|sum,v| sum + v.price}
  end

  def revenue_per_seat
    self.revenue / self.vouchers.length
  end

  def advance_sales?
    (self.end_advance_sales - 5.minutes) > Time.now
  end

  # capacity: if zero, then use show's capacity
  def capacity
    (self.max_sales <= 0 ?
     self.show.house_capacity :
     [self.max_sales, self.show.house_capacity].min )
  end

  def total_seats_left
    [self.capacity - self.compute_total_sales, 0].max
  end

  def percent_sold
    cap = self.capacity.to_f
    cap.zero? ? 0 : (100.0 * (cap - self.total_seats_left) / cap).floor
  end

  def sold_out? ; percent_sold.to_i >= Option.value(:sold_out_threshold).to_i ; end

  def nearly_sold_out? ; percent_sold.to_i >= Option.value(:nearly_sold_out_threshold).to_i ; end

  def availability_in_words
    pct = percent_sold
    pct >= Option.value(:sold_out_threshold).to_i ?  :sold_out :
      pct >= Option.value(:nearly_sold_out_threshold).to_i ? :nearly_sold_out :
      :available
  end
  
  def seats_left_for_voucher(vouchertype,cust=Customer.generic_customer)
    ValidVoucher.numseats_for_showdate_by_vouchertype(self.id, vouchertype, cust)
  end

  def seats_left(cust=Customer.generic_customer)
    ValidVoucher.numseats_for_showdate(self.id, cust)
  end

  def compute_total_sales
    return Voucher.count(:conditions => ['showdate_id =  ?', self.id])
  end

  def spoken_name
    self.show.name.gsub( /\W/, ' ')
  end

  def speak
    self.spoken_name + ", on " + self.thedate.speak
  end
  
  def printable_name
    self.show.name + " - " + self.printable_date
  end

  def printable_date
    self.thedate.to_formatted_s(:showtime)
  end
end
