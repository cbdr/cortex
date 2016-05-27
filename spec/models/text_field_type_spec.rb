require 'spec_helper'

RSpec.describe TextFieldType, type: :model do
  context "validation types" do
    it "has the acceptable validation types" do
      expect(TextFieldType::VALIDATION_TYPES).to be_present
    end

    it "includes length and presence" do
      expect(TextFieldType::VALIDATION_TYPES).to include(:length)
      expect(TextFieldType::VALIDATION_TYPES).to include(:presence)
    end
  end

  describe "#initialize" do
    let(:subject) { TextFieldType.new({ "text" => "Some Text" }, { "length" => { "maximum" => 5 } }) }

    it "saves the text from the data hash passed into it" do
      expect(subject.text).to eq("Some Text")
    end

    it "symbolizes and saves the validations hash passed into it" do
      expect(subject.validations).to eq({ length: { maximum: 5 } })
    end
  end

  describe "#acceptable_validations?" do
    let(:subject) { TextFieldType.new }

    it "returns true if the types of validations in the hash passed into it can be performed" do
      subject.validations = { presence: true }
      expect(subject.acceptable_validations?).to be true
    end

    it "returns false if any of the types of validations in the hash cannot be performed" do
      subject.validations = { presence: true, bloop: "goop" }
      expect(subject.acceptable_validations?).to be false
    end

    context "length validations" do
      it "returns true if the length validation options are allowed" do
        subject.validations = { length: { minimum: 5, maximum: 10 } }
        expect(subject.acceptable_validations?).to be true
      end

      it "returns false if the options for length validation are invalid" do
        subject.validations = { length: "string" }
        expect(subject.acceptable_validations?).to be false
      end
    end
  end

  context "validating text attribute" do
    context "when presence validation is set" do

    end

    context "when length validation is set" do

    end

    context "when length and presence are set" do
      
    end
  end
end
