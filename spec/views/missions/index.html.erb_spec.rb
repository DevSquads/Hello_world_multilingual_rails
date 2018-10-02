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
        :language => "fr"
      )
    ])
  end

  it "renders a list of missions" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Instructions".to_s, :count => 2
    assert_select "tr>td", :text => 10.to_s, :count => 2
    assert_select "tr>td", :text => "Category".to_s, :count => 2
  end
end
