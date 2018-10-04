# frozen_string_literal: true

RSpec.describe Mission, type: :model do

  xit 'validates presence of title' do
    record = Mission.new
    record.title = ''
    record.valid?
    expect(record.errors[:title]).to include('can\'t be blank')
  end

  xit 'validates presence of instructions' do
    record = Mission.new
    record.instructions = ''
    record.valid?
    expect(record.errors[:instructions]).to include('can\'t be blank')
  end

  it 'validates presence of duration' do
    record = Mission.new
    record.duration = {}
    record.valid?
    expect(record.errors[:duration]).to include('can\'t be blank')
  end

  it 'validates presence of category' do
    record = Mission.new
    record.category = ''
    record.valid?
    expect(record.errors[:category]).to include('can\'t be blank')
  end


end
