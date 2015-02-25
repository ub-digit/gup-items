require 'rails_helper'

RSpec.describe Gupea, :type => :model do
  describe "find_by_id" do
    context "with an existing id" do
      it "should return a valid object" do
        gupea = Gupea.find_by_id "12345"
        expect(gupea.errors.messages.empty?).to be_truthy
      end
      it "should return a valid object with parameters" do
        gupea = Gupea.find_by_id "12345"
        expect(gupea.title.present?).to be_truthy
        expect(gupea.pubyear.present?).to be_truthy
        # ...
      end
    end
    context "with a no existing id" do
      it "should return a invalid object" do
        gupea = Gupea.find_by_id "123459999999"
        expect(gupea.errors.messages.empty?).to be_falsey
      end
    end
    context "with no id" do
      it "should return a invalid object" do
        gupea = Gupea.find_by_id ""
        expect(gupea.errors.messages.empty?).to be_falsey
      end
    end
    context "with an invalid id" do
      it "should return nil" do
        gupea = Gupea.find_by_id "123 4321"
        expect(gupea.nil?).to be_truthy
      end
    end
  end
end


