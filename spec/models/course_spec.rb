require 'rails_helper'

RSpec.describe Course, type: :model do
    subject do
        described_class.new(name: 'A Comp Sci Course',
                            catalogue_number: 'COMP SCI 1000')
    end
    it 'is valid with valid attributes' do
        expect(subject).to be_valid
    end
    it 'is not valid without a name' do
        subject.name = nil
        expect(subject).to_not be_valid
    end
    it 'is not valid without a catalogue number' do
        subject.catalogue_number = nil
        expect(subject).to_not be_valid
    end
    it 'should have many courses' do
        t = described_class.reflect_on_association(:components)
        expect(t.macro).to eq(:has_and_belongs_to_many)
    end
end
