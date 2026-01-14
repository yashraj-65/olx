require 'rails_helper'

RSpec.describe Item, type: :model do
    subject{
        build(:item)
    }

    describe "validations" do
        it "is valid with a attributes" do
            expect(subject).to be_valid
        end
        it "is valid with a title" do
            subject.title = nil
            expect(subject).not_to be_valid
        end
        it "is valid with a prize" do
            subject.price=nil
            expect(subject).not_to be_valid
        end
        it "is valid with a desc" do
            subject.desc=nil
            expect(subject).not_to be_valid
        end
    end

    describe"callback" do
        context "set status" do
            it "set default status" do
                expect(subject.status).to  be_nil
                
                subject.save

                expect(subject.available?).to be true
            end
        end
    
    end

    describe "associations" do
        it "has many deals" do
            assoc = described_class.reflect_on_association(:deals)
            expect(assoc.macro).to eq(:has_many)
        end
        it "has many likes" do
              assoc = described_class.reflect_on_association(:likes)
              expect(assoc.macro).to eq (:has_many)
              expect(assoc.options[:as]).to eq :likeable
              expect(assoc.options[:dependent]).to eq(:destroy)
        end
        it "has many conversations" do
            assoc = described_class.reflect_on_association(:conversations)
            expect(assoc.macro).to eq(:has_many)
            expect(assoc.options[:dependent]).to eq(:destroy)
        end
    end
end