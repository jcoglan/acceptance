require 'spec/spec_helper'

describe Acceptance::ReflectsOnValidations do
  include SpecHelper
  
  describe :acceptance do
    before :each do
      @class = make_class do
        validates_acceptance_of :terms, :message => "only on our terms"
        validates_acceptance_of :on_create, :on => :create
        validates_acceptance_of :something, :allow_nil => false
        validates_acceptance_of :tests, :accept => true
      end
    end
    
    it "reflects on validates_acceptance_of :terms" do
      reflect(:terms).first.should reflect_validation_of :terms,
                                   :acceptance,
                                   :model => @class,
                                   :message => "Terms only on our terms",
                                   :on => :save,
                                   :allow_nil? => true,
                                   :accept => "1"
    end
    
    it "reflects on validates_acceptance_of :on_create" do
      reflect(:on_create).first.should reflect_validation_of :on_create,
                                       :acceptance,
                                       :on => :create
    end
    
    it "reflects on validates_acceptance_of :something" do
      reflect(:something).first.should reflect_validation_of :something,
                                       :acceptance,
                                       :allow_nil? => false
    end
    
    it "reflects on validates_acceptance_of :tests" do
      reflect(:tests).first.should reflect_validation_of :tests,
                                   :acceptance,
                                   :message => "Tests must be accepted",
                                   :accept => true
    end
    
    it "retains validation logic" do
      factory(@class, :terms => false).should_not be_valid
    end
  end
  
  describe :confirmation do
    before :each do
      @class = make_class do
        validates_confirmation_of :email, :message => "should confirm your email"
        validates_confirmation_of :password, :on => :update
      end
    end
    
    it "reflects on validates_confirmation_of :email" do
      reflect(:email).first.should reflect_validation_of :email,
                                   :confirmation,
                                   :message => "Email should confirm your email",
                                   :on => :save
    end
    
    it "reflects on validates_confirmation_of :password" do
      reflect(:password).first.should reflect_validation_of :password,
                                     :confirmation,
                                     :message => "Password doesn't match confirmation",
                                     :on => :update
    end
    
    it "retains validation logic" do
      factory(@class, :email => "one@example.com", :email_confirmation => "another@example.com").should_not be_valid
    end
  end
  
  describe :exclusion do
    before :each do
      @class = make_class do
        validates_exclusion_of :password, :in => %w[test pass]
        validates_exclusion_of :email,    :in => %w[admin], :message => "is boring"
        validates_exclusion_of :age,      :in => 18..30,    :allow_nil => true
        validates_exclusion_of :username, :in => %w[usr],   :allow_blank => true
      end
    end
    
    it "reflects on validates_exclusion_of :password" do
      reflect(:password).first.should reflect_validation_of :password,
                                      :exclusion,
                                      :in => %w[test pass],
                                      :message => "Password is reserved",
                                      :allow_nil? => false,
                                      :allow_blank? => false
    end
    
    it "reflects on validates_exclusion_of :email" do
      reflect(:email).first.should reflect_validation_of :email,
                                   :exclusion,
                                   :in => %w[admin],
                                   :message => "Email is boring"
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
        validates_inclusion_of :email,    :in => %w[admin], :message => "is boring"
        validates_inclusion_of :age,      :in => 18..30,    :allow_nil => true
        validates_inclusion_of :username, :in => %w[usr],   :allow_blank => true
      end
    end
    
    it "reflects on validates_inclusion_of :password" do
      reflect(:password).first.should reflect_validation_of :password,
                                      :inclusion,
                                      :in => %w[test pass],
                                      :message => "Password is not included in the list",
                                      :allow_nil? => false,
                                      :allow_blank? => false
    end
    
    it "reflects on validates_inclusion_of :email" do
      reflect(:email).first.should reflect_validation_of :email,
                                   :inclusion,
                                   :in => %w[admin],
                                   :message => "Email is boring"
    end
    
    it "reflects on validates_inclusion_of :age" do
      reflect(:age).first.should reflect_validation_of :age,
                                 :inclusion,
                                 :in => 18..30,
                                 :allow_nil? => true
    end
    
    it "reflects on validates_inclusion_of :username" do
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
  
  describe :format do
    before :each do
      @class = make_class do
        validates_format_of :email,    :with => /pattern/, :message => "doesn't match the pattern"
        validates_format_of :password, :with => /pattern/, :allow_nil => true
        validates_format_of :username, :with => /pattern/, :allow_blank => true
        validates_format_of :address,  :with => /pattern/, :on => :create
      end
    end
    
    it "reflects on validates_format_of :email" do
      reflect(:email).first.should reflect_validation_of :email,
                                   :format,
                                   :message => "Email doesn't match the pattern",
                                   :allow_nil? => false,
                                   :allow_blank? => false,
                                   :with => /pattern/,
                                   :on => :save
    end
    
    it "reflects on validates_format_of :password" do
      reflect(:password).first.should reflect_validation_of :password,
                                      :format,
                                      :message => "Password is invalid",
                                      :allow_nil? => true,
                                      :with => /pattern/
    end
    
    it "reflects on validates_format_of :username" do
      reflect(:username).first.should reflect_validation_of :username,
                                      :format,
                                      :allow_blank? => true,
                                      :with => /pattern/
    end
    
    it "reflects on validates_format_of :address" do
      reflect(:address).first.should reflect_validation_of :address,
                                     :format,
                                     :on => :create,
                                     :with => /pattern/
    end
    
    it "retains validation logic" do
      factory(@class, :email => "wrong").should_not be_valid
      factory(@class, :password => "wrong").should_not be_valid
      factory(@class, :username => "wrong").should_not be_valid
      factory(@class, :address => "wrong").should_not be_valid
    end
  end
  
  describe :length do
    before :each do
      @class = make_class do
        validates_length_of :username, :is => 8, :message => "must be eight chars"
        validates_length_of :email, :maximum => 60, :allow_nil => true
        validates_length_of :password, :minimum => 3, :allow_blank => true
        validates_length_of :address, :within => 1..22, :on => :update
      end
    end
    
    it "reflects on validates_length_of :username" do
      reflect(:username).first.should reflect_validation_of :username,
                                      :length,
                                      :maximum => nil,
                                      :minimum => nil,
                                      :is => 8,
                                      :within => nil,
                                      :allow_nil? => false,
                                      :allow_blank? => false,
                                      :too_long => nil,
                                      :too_short => nil,
                                      :wrong_length => "Username is the wrong length (should be 8 characters)",
                                      :message => "Username must be eight chars",
                                      :on => :save
    end
    
    it "reflects on validates_length_of :email" do
      reflect(:email).first.should reflect_validation_of :email,
                                   :length,
                                   :maximum => 60,
                                   :is => nil,
                                   :too_long => "Email is too long (maximum is 60 characters)",
                                   :wrong_length => nil,
                                   :message => "Email is too long (maximum is 60 characters)",
                                   :allow_nil? => true
    end
    
    it "reflects on validates_length_of :password" do
      reflect(:password).first.should reflect_validation_of :password,
                                      :length,
                                      :minimum => 3,
                                      :is => nil,
                                      :too_short => "Password is too short (minimum is 3 characters)",
                                      :wrong_length => nil,
                                      :message => "Password is too short (minimum is 3 characters)",
                                      :allow_blank? => true
    end
    
    it "reflects on validates_length_of :address" do
      reflect(:address).first.should reflect_validation_of :address,
                                     :length,
                                     :is => nil,
                                     :within => 1..22,
                                     :too_short => "Address is too short (minimum is 1 characters)",
                                     :too_long => "Address is too long (maximum is 22 characters)",
                                     :wrong_length => nil,
                                     :message => nil,
                                     :on => :update
    end
  end
  
  describe :presence do
    before :each do
      @class = make_class do
        validates_presence_of :username, :message => "You should have a name"
        validates_presence_of :email
      end
    end
    
    it "reflects on validates_presence_of :username" do
      reflect(:username).first.should reflect_validation_of :username,
                                      :presence,
                                      :message => "You should have a name"
    end
    
    it "reflects on validates_presence_of :email" do
      reflect(:email).first.should reflect_validation_of :email,
                                      :presence,
                                      :message => nil
    end
    
    it "retains validation logic" do
      factory(@class, :username => nil).should_not be_valid
      factory(@class, :email => nil).should_not be_valid
    end
  end
  
  describe :uniqueness do
    before :each do
      @class = make_class do
        validates_uniqueness_of :username, :message => "You should have a unique name"
        validates_uniqueness_of :email, :allow_blank => true
        validates_uniqueness_of :password, :scope => :username, :case_sensitive? => false
      end
    end
    
    it "reflects on validates_uniqueness_of :username" do
      reflect(:username).first.should reflect_validation_of :username,
                                      :uniqueness,
                                      :message => "You should have a unique name",
                                      :allow_blank? => false,
                                      :allow_nil? => false,
                                      :scope => nil,
                                      :case_sensitive? => true
    end
    
    it "reflects on validates_uniqueness_of :email" do
      reflect(:email).first.should reflect_validation_of :email,
                                   :uniqueness,
                                   :message => nil,
                                   :allow_blank? => true
    end
    
    it "reflects on validates_uniqueness_of :password" do
      reflect(:password).first.should reflect_validation_of :password,
                                      :uniqueness,
                                      :message => nil,
                                      :scope => :username
    end
  end
  
end

