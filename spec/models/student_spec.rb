require 'rails_helper'

RSpec.describe Student, type: :model do
    subject { described_class.new }
    it 'is valid with valid attributes' do
        expect(subject).to be_valid
    end
end
