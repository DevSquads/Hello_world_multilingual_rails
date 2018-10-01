require 'rails_helper'

RSpec.describe "missions/new", type: :view do
  before(:each) do
    assign(:mission, Mission.new(
      :title => "MyString",
      :instructions => "MyString",
      :duration => "",
      :category => "MyString"
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
end
