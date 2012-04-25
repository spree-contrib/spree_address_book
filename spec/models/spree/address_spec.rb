require 'spec_helper'

describe Spree::Address do
  it "should consider two address records which are identical aside from user_id to be identical" do
    
  end

  describe "when address has order associated" do
    it "should not be editable" do
      
    end

    it "should not be able to be deleted" do
      
    end

    it "should not remove the record on destroy from the DB" do
      
    end
  end

  describe "when has no order association" do
    it "should be able to be deleted" do
      
    end

    it "should be editable" do
      
    end

    it "should remove the record on destroy from the DB" do
      
    end
  end
end
