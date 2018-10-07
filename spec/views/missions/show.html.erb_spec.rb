require 'rails_helper'

RSpec.describe "missions/show", type: :view do
  before(:each) do
    @mission = assign(:mission, Mission.create!(
      :title => "Title",
      :instructions => "Instructions",
      :duration => 10,
      :category => "Category",
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Instructions/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Category/)
  end
end
