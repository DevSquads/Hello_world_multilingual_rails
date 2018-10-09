# frozen_string_literal: true
require 'rails_helper'
require 'locale_helpers'

RSpec.describe 'missions/index', type: :view do
  before(:each) do
    reset_locale 'en_test'
    assign(:missions, [
             Mission.create!(
               title: 'Title one',
               instructions: 'Instruction one',
               duration: 10,
               category: 'Category one'
             ),
             Mission.create!(
               title: 'Title two',
               instructions: 'Instruction two',
               duration: 11,
               category: 'Category two'
             )
           ])
  end

  it 'renders a list of missions' do
    reset_locale 'en_test'
    render
    assert_select 'tr>td', text: '1'.to_s, count: 1
    assert_select 'tr>td', text: 'Title one'.to_s, count: 1
    assert_select 'tr>td', text: 'Instruction one'.to_s, count: 1
    assert_select 'tr>td', text: 10.to_s, count: 1
    assert_select 'tr>td', text: 'Category one'.to_s, count: 1

    assert_select 'tr>td', text: '2'.to_s, count: 1
    assert_select 'tr>td', text: 'Title two'.to_s, count: 1
    assert_select 'tr>td', text: 'Instruction two'.to_s, count: 1
    assert_select 'tr>td', text: 11.to_s, count: 1
    assert_select 'tr>td', text: 'Category two'.to_s, count: 1
  end

  after(:each) do
    remove_locale_file 'en_test'
  end
end
