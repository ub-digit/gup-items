require 'rails_helper'

RSpec.describe Pubmed, :type => :model do
  describe "find_by_id" do
    context "with an existing id" do
      it "should return a valid object" do
        pubmed = Pubmed.find_by_id "25505574"
        expect(pubmed.errors.messages.empty?).to be_truthy
      end
      it "should return a valid object with parameters" do
        pubmed = Pubmed.find_by_id "25505574"
        expect(pubmed.title.present?).to be_truthy
        expect(pubmed.pubyear.present?).to be_truthy
        # ...
      end
    end
    context "with a no existing id" do
      it "should return a invalid object" do
        pubmed = Pubmed.find_by_id "255055741354975"
        expect(pubmed.errors.messages.empty?).to be_falsey
      end
    end
    context "with no id" do
      it "should return a invalid object" do
        pubmed = Pubmed.find_by_id ""
        expect(pubmed.errors.messages.empty?).to be_falsey
      end
    end
    context "with an invalid id" do
      it "should return nil" do
        pubmed = Pubmed.find_by_id "123 4321"
        expect(pubmed.nil?).to be_truthy
      end
    end
  end
end


