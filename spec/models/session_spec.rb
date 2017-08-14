require 'rails_helper'

RSpec.describe Session, type: :model do
    subject do
        described_class.new(time: Time.new(2017, 7, 30, 10, 0, 0, '+09:30'), length: 1,
                            day: 'Monday', weeks: [1, 3, 5, 7, 9, 11], component_code: 'LE01',
                            capacity: 50)
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
    it 'is not valid without a component code' do
        subject.component_code = nil
        expect(subject).to_not be_valid
    end
    it 'is not valid without a length' do
        subject.length = nil
        expect(subject).to_not be_valid
    end
    it 'is not valid without a capacity' do
        subject.capacity = nil
        expect(subject).to_not be_valid
    end
    it 'should have one component' do
        t = described_class.reflect_on_association(:component)
        expect(t.macro).to eq(:belongs_to)
    end
    it 'should have many students' do
        t = described_class.reflect_on_association(:students)
        expect(t.macro).to eq(:has_and_belongs_to_many)
    end
end
