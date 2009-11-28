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
      factory(@class, :terms => false).should_not be_valid
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
      factory(@class, :email => "one@example.com", :email_confirmation => "another@example.com").should_not be_valid
    end
  end
  
  describe :exclusion do
    before :each do
      @class = make_class do
        validates_exclusion_of :password, :in => %w[test pass]
        validates_exclusion_of :email,    :in => %w[admin], :message => "Don't use a boring address"
        validates_exclusion_of :age,      :in => 18..30,    :allow_nil => true
        validates_exclusion_of :username, :in => %w[usr],   :allow_blank => true
      end
    end
    
    it "reflects on validates_exclusion_of :password" do
      reflect(:password).first.should reflect_validation_of :password,
                                      :exclusion,
                                      :in => %w[test pass],
                                      :message => nil,
                                      :allow_nil? => false,
                                      :allow_blank? => false
    end
    
    it "reflects on validates_exclusion_of :email" do
      reflect(:email).first.should reflect_validation_of :email,
                                   :exclusion,
                                   :in => %w[admin],
                                   :message => "Don't use a boring address"
    end
    
    it "reflects on validates_exclusion_of :age" do
      reflect(:age).first.should reflect_validation_of :age,
                                 :exclusion,
                                 :in => 18..30,
                                 :allow_nil? => true
    end
    
    it "reflects on validates_exclusion_of :username" do
      reflect(:username).first.should reflect_validation_of :username,
                                      :exclusion,
                                      :in => %w[usr],
                                      :allow_blank? => true
    end
    
    it "retains validation logic" do
      factory(@class, :password => "test").should_not be_valid
      factory(@class, :email => "admin").should_not be_valid
      factory(@class, :age => 24).should_not be_valid
      factory(@class, :username => "usr").should_not be_valid
    end
  end
  
  describe :inclusion do
    before :each do
      @class = make_class do
        validates_inclusion_of :password, :in => %w[test pass]
        validates_inclusion_of :email,    :in => %w[admin], :message => "Don't use a boring address"
        validates_inclusion_of :age,      :in => 18..30,    :allow_nil => true
        validates_inclusion_of :username, :in => %w[usr],   :allow_blank => true
      end
    end
    
    it "reflects on validates_exclusion_of :password" do
      reflect(:password).first.should reflect_validation_of :password,
                                      :inclusion,
                                      :in => %w[test pass],
                                      :message => nil,
                                      :allow_nil? => false,
                                      :allow_blank? => false
    end
    
    it "reflects on validates_exclusion_of :email" do
      reflect(:email).first.should reflect_validation_of :email,
                                   :inclusion,
                                   :in => %w[admin],
                                   :message => "Don't use a boring address"
    end
    
    it "reflects on validates_exclusion_of :age" do
      reflect(:age).first.should reflect_validation_of :age,
                                 :inclusion,
                                 :in => 18..30,
                                 :allow_nil? => true
    end
    
    it "reflects on validates_exclusion_of :username" do
      reflect(:username).first.should reflect_validation_of :username,
                                      :inclusion,
                                      :in => %w[usr],
                                      :allow_blank? => true
    end
    
    it "retains validation logic" do
      factory(@class, :password => "not test").should_not be_valid
      factory(@class, :email => "not admin").should_not be_valid
      factory(@class, :age => 44).should_not be_valid
      factory(@class, :username => "not usr").should_not be_valid
    end
  end
  
end

