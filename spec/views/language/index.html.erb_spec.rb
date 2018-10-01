require 'rails_helper'

RSpec.describe "language/index.html.erb", type: :view do
  before(:all) do
    @expected_key = "hello"
    assign(:key_array, [@expected_key])
  end

  it 'should contain form with input field to language' do
    render
    expect(rendered).to have_css("p#language_label")
    expect(rendered).to have_css("input#language_name")
  end

  it 'should render the first locale field Hello in the title' do
    render
    expect(rendered).to have_xpath("//h1[contains(text(),\"#{I18n.t('missions.hello')}\")]")
  end

  it 'should have a translations parent notation in the input names' do
    render
    expect(rendered).to have_css('input[name="translations[hello]"]')
  end

  it 'should show the dictionary form with the keys from locale' do
    render
    expect(rendered).to have_css("form#addLanguageForm")
    expect(rendered).to have_css("input[name=\"translations[#{@expected_key}]\"]")
    expect(rendered).to have_xpath("//p[contains(text(),\"#{@expected_key}\")]")
  end

  it 'should contain a button Add Language' do
    render
    expect(rendered).to have_css("input#add_language")
  end

  it 'should contain a form that redirect to /add_lang' do
    render
    expect(rendered).to have_css('form[action="/language"]')
    expect(rendered).to have_css('form[method="post"]')
  end
end
