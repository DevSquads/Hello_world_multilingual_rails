# frozen_string_literal: true
require 'rails_helper'
require 'locale_helpers'

RSpec.describe 'missions/index', type: :view do
  before(:each) do
    reset_locale 'en_test'
    assign(:missions, [
             Mission.create!(
               title: 'Title',
               instructions: 'Instructions',
               duration: 10,
               category: 'Category'
             ),
             Mission.create!(
               title: 'Title',
               instructions: 'Instructions',
               duration: 10,
               category: 'Category'
             )
           ])
  end

  it 'renders a list of missions' do
    reset_locale 'en_test'
    render
    assert_select 'tr>td', text: 'Title'.to_s, count: 2
    assert_select 'tr>td', text: 'Instructions'.to_s, count: 2
    assert_select 'tr>td', text: 10.to_s, count: 2
    assert_select 'tr>td', text: 'Category'.to_s, count: 2
  end

  after(:each) do
    remove_locale_file 'en_test'
  end
end
