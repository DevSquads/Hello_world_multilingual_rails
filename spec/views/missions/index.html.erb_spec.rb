require 'rails_helper'

RSpec.describe "missions/index", type: :view do
  before(:each) do
    assign(:missions, [
      Mission.create!(
        :title => "Title",
        :instructions => "Instructions",
        :duration => 10,
        :category => "Category",
        :language => "en"
      ),
      Mission.create!(
        :title => "Title",
        :instructions => "Instructions",
        :duration => 10,
        :category => "Category",
        :language => "en"
      )
    ])
  end

  it "renders a list of missions" do
    render
    assert_select "tr>td", :text => "dummy title1".to_s, :count => 1
    assert_select "tr>td", :text => "dummy title2".to_s, :count => 1
    assert_select "tr>td", :text => "dummy instructions1".to_s, :count => 1
    assert_select "tr>td", :text => "dummy instructions2".to_s, :count => 1
    assert_select "tr>td", :text => 10.to_s, :count => 2
    assert_select "tr>td", :text => "Category".to_s, :count => 2
  end
end
