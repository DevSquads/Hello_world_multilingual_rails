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


  after(:all) do
    remove_locale_file 'en_test'
  end
end
