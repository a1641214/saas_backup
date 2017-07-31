require 'rails_helper'

RSpec.describe Session, type: :model do
    subject do
        described_class.new(time: Time.new(2017, 7, 30, 10, 0, 0, '+09:30'),
                            day: 'Monday', weeks: [1, 3, 5, 7, 9, 11])
    end
    it 'is valid with valid attributes' do
        expect(subject).to be_valid
    end
    it 'is not valid without a time' do
        subject.time = nil
        expect(subject).to_not be_valid
    end
    it 'is not valid without a day' do
        subject.day = nil
        expect(subject).to_not be_valid
    end
    it 'is not valid without a week' do
        subject.weeks = nil
        expect(subject).to_not be_valid
    end
    it 'should have one component' do
        t = described_class.reflect_on_association(:component)
        expect(t.macro).to eq(:belongs_to)
    end
end
