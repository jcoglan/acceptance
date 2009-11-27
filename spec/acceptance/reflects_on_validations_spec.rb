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
      @terms.size.should == 1
      @terms.first.macro.should == :acceptance
      @terms.first.field.should == :terms
      @terms.first.message.should == "Only on our terms"
    end
    
    it "reflects on validates_acceptance_of :tests" do
      @tests.size.should == 1
      @tests.first.macro.should == :acceptance
      @tests.first.field.should == :tests
      @tests.first.message.should be_nil
    end
  end
  
end

