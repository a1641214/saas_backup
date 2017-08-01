require 'rails_helper'

RSpec.describe Course, type: :model do
    subject { described_class.new(name: 'A Comp Sci Course', catalogue_number: 'COMP SCI 1000') }
    it 'is valid with valid attributes' do
        expect(subject).to be_valid
    end
    it 'is not valid without a name' do
        subject.name = nil;
        expect(subject).to_not be_valid
    end
    it 'is not valid without a catalogue number' do
        subject.catalogue_number = nil
        expect(subject).to_not be_valid
    end
end
