require 'spec/spec_helper'

describe Acceptance::ReflectsOnValidations do
  include SpecHelper
  
  describe :acceptance do
    before :each do
      @class = make_class { validates_acceptance_of :terms }
      @reflections = @class.reflect_on_validations_for(:terms)
    end
    
    it "reflects on :validates_acceptance_of" do
      @reflections.size.should == 1
      
      ref = @reflections.first
      ref.macro.should == :acceptance
      ref.field.should == :terms
    end
  end
  
end

