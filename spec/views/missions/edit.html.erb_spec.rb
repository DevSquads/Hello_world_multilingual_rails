require 'rails_helper'

RSpec.describe "missions/edit", type: :view do
  before(:each) do
    reset_locale 'en_test'
    @mission = assign(:mission, Mission.create!(
      :title => "MyString",
      :instructions => "MyString",
      :duration => 10,
      :category => "MyString",
    ))
  end

  it "renders the edit mission form" do
    render

    assert_select "form[action=?][method=?]", mission_path(@mission), "post" do

      assert_select "input[name=?]", "mission[title]"

      assert_select "input[name=?]", "mission[instructions]"

      assert_select "input[name=?]", "mission[duration]"

      assert_select "input[name=?]", "mission[category]"

      assert_select "input[name=?]", "mission[language]"
    end
  end
end
