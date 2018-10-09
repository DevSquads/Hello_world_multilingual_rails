require 'rails_helper'
require 'locale_helpers'
RSpec.describe "missions/new", type: :view do
  before(:each) do
    reset_locale 'en_test'

    assign(:mission, Mission.new(
        :title => "MyString",
        :instructions => "MyString",
        :duration => 12,
        :category => "MyString",
    ))

    assign(:missions, [])
  end

  it "renders new mission form" do
    render

    assert_select "form[action=?][method=?]", missions_path, "post" do

      assert_select "input[name=?]", "mission[title]"

      assert_select "input[name=?]", "mission[instructions]"

      assert_select "input[name=?]", "mission[duration]"

      assert_select "input[name=?]", "mission[category]"
    end
  end

  it "should render the duration form as number field" do
    render
    assert_select "input[name='mission[duration]']", :type => :number
  end

  it "should render the language field as data list" do
    render
    assert_select "input[name=?]", "mission[language]"
    assert_select "input[list=?]", "languages"

    assert_select "datalist[id=?]", "languages"

    assert_select "datalist[id='languages']" do
      assert_select "option"
    end
  end

  it "should render the locale languages in the language datalist" do
    render

    available_locale_length = I18n.available_locales.length
    expect(available_locale_length).to eql(3)

    assert_select "datalist[id='languages']" do
      assert_select "option", available_locale_length
    end
  end

  it "should render  all locale in the option list of a filter drop list" do
    render
    assert_select "select[id='filter_languages']" do
      assert_select "option[id=?]", "All"
    end
  end

  it "should render the available locales in filter drop list" do
    reset_locale 'fr_test'
    render

    available_locale_length = I18n.available_locales.length
    expect(available_locale_length).to eql(4)

    assert_select "select[id='filter_languages']" do
      four_languages_plus_all = available_locale_length + 1
      assert_select "option", four_languages_plus_all
    end
    ensure
    remove_locale_file 'fr_test'
  end

  it 'filter button should exists in the homepage' do
    render
    assert_select '#filter_languages'

  end

  after(:all) do
    remove_locale_file 'en_test'
  end
end
