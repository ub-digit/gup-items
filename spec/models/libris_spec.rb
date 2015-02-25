require 'rails_helper'

RSpec.describe Libris, :type => :model do
  describe "find_by_id" do
    context "with an existing id" do
      it "should return a valid object" do
        libris = Libris.find_by_id "12345"
        expect(libris.errors.messages.empty?).to be_truthy
      end
      it "should return a valid object with parameters" do
        libris = Libris.find_by_id "978-91-637-1542-6"
        expect(libris.title.present?).to be_truthy
        expect(libris.pubyear.present?).to be_truthy
        # ...
      end
    end
    context "with a no existing id" do
      it "should return a invalid object" do
        libris = Libris.find_by_id "978-91-637-1542-6123456789"
        expect(libris.errors.messages.empty?).to be_falsey
      end
    end
    context "with no id" do
      it "should return a invalid object" do
        libris = Libris.find_by_id ""
        expect(libris.errors.messages.empty?).to be_falsey
      end
    end
    context "with an invalid id" do
      it "should return nil" do
        libris = Libris.find_by_id "978 91 637 1542 6123456789"
        expect(libris.nil?).to be_truthy
      end
    end
  end
end


