require 'rails_helper'

# Be sure to include AuthenticatedTestHelper in spec/rails_helper.rb instead
# Then, you can remove it from this and the units test.

describe SessionsController do
  # Login for an admin
  describe 'admin view' do
    before(:each) do
      login_as_boxoffice_manager
      # we must set an action FROM WHICH this request was given
      request.env['HTTP_REFERER'] = customer_path(:boxoffice_manager)
    end
    it 'can be disabled' do
      get :temporarily_disable_admin
      @controller.send(:is_boxoffice).should_not be_truthy
    end
    it 'can be reenabled' do
      get :reenable_admin
      @controller.send(:is_boxoffice).should be_truthy
    end
  end

  describe 'login' do
    before(:each) do 
      ApplicationController.send(:public, :current_user)
      @customer  = create(:customer)  # default password is 'pass' in factory
      @params = { :email => @customer.email, :password => 'pass' }
    end
    it 'sets cookie if I check remember-me' do
      @params['remember_me'] = '1'
      expect(controller).to receive(:create_or_refresh_remember_cookie!)
      post :create, @params
    end

    it "updates my last_login" do
      allow(Customer).to receive(:authenticate).and_return(@customer)
      expect(@customer).to receive(:update_attribute).with(:last_login, anything())
      post(:create, @params)
    end
    it "doesn't send password back on failed login" do 
      @params[:password] = 'FROBNOZZ'
      post(:create, @params)
      response.should_not have_text(/FROBNOZZ/i)
    end
  end

  describe "on logout" do
    before do 
      login_as create(:customer, :email => 'quentin@email.com')
    end
    it 'logs me out' do
      expect(controller).to receive(:logout_keeping_session!)
      get :destroy
    end
    it 'redirects me to the home page' do
      get :destroy
      expect(response).to be_redirect
    end
  end
  
end
