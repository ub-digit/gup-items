
require 'rails_helper'

RSpec.describe Scopus, :type => :model do
  describe "find_by_id" do
    context "with an existing id" do
      it "should return a valid object" do
        scopus = Scopus.find_by_id "10.1109/IJCNN.2008.4634188"
        expect(scopus.errors.messages.empty?).to be_truthy
      end
      it "should return a valid object with parameters" do
        scopus = Scopus.find_by_id "10.1109/IJCNN.2008.4634188"
        expect(scopus.title.present?).to be_truthy
        expect(scopus.pubyear.present?).to be_truthy
        # ...
      end
    end
    context "with a no existing id" do
      it "should return a invalid object" do
        scopus = Scopus.find_by_id "123456789/987654321"
        expect(scopus.errors.messages.empty?).to be_falsey
      end
    end
    context "with no id" do
      it "should return nil" do
        scopus = Scopus.find_by_id ""
        expect(scopus.nil?).to be_truthy
      end
    end
    context "with an invalid id" do
      it "should return nil" do
        scopus = Scopus.find_by_id "10.1109 /IJCNN.2008.4634188"
        expect(scopus.nil?).to be_truthy
      end
    end
  end
end


