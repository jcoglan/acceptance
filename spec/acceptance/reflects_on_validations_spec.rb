require 'spec/spec_helper'

describe Acceptance::ReflectsOnValidations do
  include SpecHelper
  
  describe :acceptance do
    before :each do
      @class = make_class do
        validates_acceptance_of :terms, :message => "Only on our terms"
        validates_acceptance_of :tests
      end
      @terms = reflect :terms
      @tests = reflect :tests
    end
    
    it "reflects on validates_acceptance_of :terms" do
      @terms.first.should reflect_validation_of :terms,
                          :acceptance,
                          :message => "Only on our terms"
    end
    
    it "reflects on validates_acceptance_of :tests" do
      @tests.first.should reflect_validation_of :tests,
                          :acceptance,
                          :message => nil
    end
    
    it "retains validation logic" do
      @class.new(:terms => false).should_not be_valid
    end
  end
  
  describe :confirmation do
    before :each do
      @class = make_class do
        validates_confirmation_of :email, :message => "You should confirm your email"
        validates_confirmation_of :password
      end
      @email    = reflect :email
      @password = reflect :password
    end
    
    it "reflects on validates_confirmation_of :email" do
      @email.first.should reflect_validation_of :email,
                          :confirmation,
                          :message => "You should confirm your email"
    end
    
    it "reflects on validates_confirmation_of :password" do
      @password.first.should reflect_validation_of :password,
                             :confirmation,
                             :message => nil
    end
    
    it "retains validation logic" do
      @class.new(:email => "one@example.com", :email_confirmation => "another@example.com").should_not be_valid
    end
  end
  
end

