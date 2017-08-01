require 'rails_helper'

RSpec.describe Student, type: :model do
    subject { described_class.new }
    it 'is valid with valid attributes' do
        expect(subject).to be_valid
    end
    it 'should have many courses' do
        t = described_class.reflect_on_association(:courses)
        expect(t.macro).to eq(:has_and_belongs_to_many)
    end
    it 'should have many sessions' do
        t = described_class.reflect_on_association(:sessions)
        expect(t.macro).to eq(:has_and_belongs_to_many)
    end
end
