# frozen_string_literal: true

require 'rails_helper'
require 'locale_helpers'

RSpec.describe Mission, type: :model do
  before(:all) do
    reset_locale 'en'
  end

  it 'validates presence of title' do
    record = Mission.new
    record.title = ''
    record.valid?
    expect(record.errors[:title]).to include('can\'t be blank')
  end

  it 'validates presence of instructions' do
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

  it 'should create mission with successful validation, no errors ' do
    reset_locale 'en_test'

    record = Mission.create! ({
      title: 'initial_title',
      instructions: 'initial_instruction',
      category: 'initial_category',
      duration: 5
    })

    reset_locale 'en_test'
    expect(record.errors.messages).to eql({})
  end
end
