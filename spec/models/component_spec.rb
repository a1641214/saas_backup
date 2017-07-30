require 'rails_helper'

RSpec.describe Component, type: :model do
    subject { described_class.new(class_type: 'Lecture') }
    it 'is valid with valid attributes' do
        expect(subject).to be_valid
    end
    it 'is not valid without a type' do
        subject.class_type = nil
        expect(subject).to_not be_valid
    end
end
