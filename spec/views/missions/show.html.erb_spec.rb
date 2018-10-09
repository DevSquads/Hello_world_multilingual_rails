require 'rails_helper'

RSpec.describe 'missions/show', type: :view do
  before(:each) do
    reset_locale 'en_test'
    @mission = assign(:mission, Mission.create!(
      :title => 'Title',
      :instructions => 'Instructions',
      :duration => 10,
      :category => 'Category',
    ))
  end

  it 'renders attributes in <p>' do
    reset_locale 'en_test'
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Instructions/)
    expect(rendered).to match(/10/)
    expect(rendered).to match(/Category/)
  end

  after(:all) do
    remove_locale_file 'en_test'
  end
end
