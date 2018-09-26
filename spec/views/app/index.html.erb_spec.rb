require 'rails_helper'

RSpec.describe "app/index.html.erb", type: :view do
  it 'should contain form with input field to language' do
    assign(:dictKeys, [])
    render
    expect(rendered).to have_css("p#language_label")
    expect(rendered).to have_css("input#language_name")
  end

  it 'should show the dictionary form with the keys from locale' do
    expected_key = "hello"
    assign(:dictKeys, [expected_key])

    render
    expect(rendered).to have_css("form#addLanguageForm")
    expect(rendered).to have_css("input[name=\"#{expected_key}\"]")

    expect(rendered).to have_xpath("//p[contains(text(),\"#{expected_key}\")]")
  end

  it 'should contain a button Add Language' do
    assign(:dictKeys, [])
    render
    expect(rendered).to have_css("input#add_language")
  end

  it 'should contain a form that redirect to /add_lang' do
    expected_key = "hello"
    assign(:dictKeys, [expected_key])

    render
    expect(rendered).to have_css('form[action="/app"]')
    expect(rendered).to have_css('form[method="post"]')
  end
end
