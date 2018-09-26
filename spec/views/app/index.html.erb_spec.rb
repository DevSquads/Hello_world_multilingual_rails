require 'rails_helper'

RSpec.describe "app/index.html.erb", type: :view do

  it 'should contain button to add language' do
    assign(:dictKeys, [])
    render
    expect(rendered).to match("<button>")
    expect(rendered).to match("Add Language")
  end

  it 'should show the dictionary form with the keys from locale' do
    expected_key = "hello"
    assign(:dictKeys, [expected_key])

    render
    expect(rendered).to have_css("form#addLanguageForm")
    expect(rendered).to have_xpath("//p[contains(text(),\"#{expected_key}\")]")
  end

  it 'should contain a form that redirect to /add_lang' do
    expected_key = "hello"
    assign(:dictKeys, [expected_key])

    render
    expect(rendered).to have_css('form[action="/app/create"]')
  end

end
