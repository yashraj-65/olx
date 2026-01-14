require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
      build(:user)
  }
    describe "validations" do
          it "is valid with valid attributes" do
            expect(subject).to be_valid 
          end

          it "is invalid without a name" do 
            subject.name = nil 
            expect(subject).not_to be_valid 
          end

          it "is invalid with a weak password" do
            subject.password = "onlylowercase1!"
            subject.password_confirmation = "onlylowercase1!"
            expect(subject).not_to be_valid 
          end
    end
    describe "callback" do
      it "creates buyer profiles" do
       expect { subject.save }.to change(Buyer, :count).by(1)
        expect(subject.buyer).to be_present
      end
    end
    describe "associations" do
        it "has many likes" do
          association = described_class.reflect_on_association(:likes)
          expect(association.macro).to eq(:has_many)
        end
        it "has many messages" do
          association = described_class.reflect_on_association(:messages)
          expect(association.macro).to eq(:has_many)   #rails stores association iside insdie a hash in clas variable.using that we can verify assoc without going to db
        end
        it "has one buyer" do
          association = described_class.reflect_on_association(:buyer)
          expect(association.macro).to eq(:has_one)
          expect(association.options[:as]).to eq :userable
        end
         it "has one seller" do
          association = described_class.reflect_on_association(:seller)
          expect(association.macro).to eq(:has_one)
             expect(association.options[:as]).to eq :userable
        end
        it "has many reviews through buyer and seller" do
          expect(User.reflect_on_association(:reviews_as_reviewer).options[:through]).to eq :buyer
          expect(User.reflect_on_association(:reviews_as_seller).options[:through]).to eq :seller
        end
        it "has many deals as buyer and seller" do
          expect(described_class.reflect_on_association(:deals_as_buyer).options[:through]).to eq :buyer
          expect(described_class.reflect_on_association(:deals_as_seller).options[:through]).to eq :seller
        end
        
    end
end