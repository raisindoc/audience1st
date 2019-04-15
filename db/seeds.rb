# Seed data for Audience1st

class Audience1stSeeder

  def self.seed_all
    self.create_options
    self.create_special_customers
    self.create_default_account_code
  end

  # Options
  # Basic options for running features and specs


  #  Special customers that must exist and cannot be deleted

  require 'customer'
  @@special_customers = {
    :walkup => {
      :role => -1,
      :first_name => 'WALKUP',
      :last_name => 'CUSTOMER',
      :blacklist => true,
      :e_blacklist => true
    },
    :boxoffice_daemon => {
      :role => -2,
      :first_name => 'BoxOffice',
      :last_name => 'Daemon',
      :blacklist => true,
      :e_blacklist => true
    },
    :anonymous => {
      :role => -3,
      :first_name => 'ANONYMOUS',
      :last_name => 'CUSTOMER',
      :blacklist => true,
      :e_blacklist => true
    }
  }

  def self.create_special_customers
    Rails.logger.info "Creating special customers"
    # Create Admin (God) login
    unless Customer.find_by_role(100)
      admin = Customer.new(:first_name => 'Super',
        :last_name => 'Administrator',
        :password => 'admin',
        :email => 'admin@audience1st.com')
      admin.created_by_admin = true
      admin.role = 100
      admin.last_login = Time.current
      admin.save!
    end
    @@special_customers.each_pair do |which, attrs|
      unless Customer.find_by_role(attrs[:role])
        c = Customer.new(attrs.except(:role))
        c.role = attrs[:role]
        c.created_by_admin = true
        c.save!
      end
    end
  end
  
  def self.create_default_account_code
    Rails.logger.info "Creating default account code"
    byebug
    a = AccountCode.first ||
      AccountCode.create!(:name => 'General Fund', :code => '0000', :description => 'General Fund')
    id = a.id
    # set it as default account code for various things
    Option.first.update_attributes!(
      :default_donation_account_code => a.id,
      :default_donation_account_code_with_subscriptions => a.id,
      :default_retail_account_code => a.id,
      :subscription_order_service_charge_account_code => a.id,
      :regular_order_service_charge_account_code => a.id,
      :classes_order_service_charge_account_code => a.id)
  end

  def self.create_options
    Rails.logger.info "Creating default options"
    option = Option.new(
      :venue => 'A1 Staging Theater',
      :advance_sales_cutoff => 60,
      :sold_out_threshold => 90,
      :nearly_sold_out_threshold => 80,
      :allow_gift_tickets => false,
      :allow_gift_subscriptions => false,
      :season_start_month => 1,
      :season_start_day => 1,
      :cancel_grace_period => 1440,
      :send_birthday_reminders => 0,
      :terms_of_sale => 'Sales Final',
      :precheckout_popup => 'Please double check dates',
      :default_retail_account_code =>  9999,
      :default_donation_account_code => 9999,
      :default_donation_account_code_with_subscriptions => 9999,
      :allow_guest_checkout => true,
      :homepage_ticket_sales_text => 'Get Tickets',
      :homepage_subscription_sales_text => 'Subscribe to Our Season',
      :privacy_policy_url => '',
      :stylesheet_url => 'https://rawgit.com/armandofox/stylesheets/master/sandbox/default.css',
      :stripe_key => Figaro.env.STRIPE_KEY!,
      :stripe_secret => Figaro.env.STRIPE_SECRET!,
      :sendgrid_key_value => '',
      :staff_access_only => false
      )
    option.save!
  end 
  self.seed_all

end

