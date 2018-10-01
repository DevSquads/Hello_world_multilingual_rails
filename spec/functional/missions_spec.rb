# frozen_string_literal: true

require 'rails_helper'

feature 'Mission' do

  scenario 'should create successfully' do
    visit 'http://localhost:3000/missions/new'

    fill_in 'mission_title', with: 'New Mission'

    fill_in 'mission_instructions', with: 'New Mission Description'

    fill_in 'mission_duration', with: '22'

    fill_in 'mission_category', with: 'Healthy'

    click_button 'Create Mission'

    expect(find('p#notice').text).to eql('Mission was successfully created.')
    expect(current_path).to eql('/missions/1')
  end

  scenario 'should edit successfully' do
    Mission.create!(title: 'title', instructions: 'instructions', duration: 10, category: 'category')

    visit 'http://localhost:3000/missions/1/edit'

    fill_in 'mission_title', with: 'edited mission title'

    fill_in 'mission_instructions', with: 'edited mission title'

    click_button 'Update Mission'

    expect(find('p#notice').text).to eql('Mission was successfully updated.')
    expect(current_path).to eql('/missions/1')
  end

  scenario 'should show all missions when go to missions/' do
    Mission.create!(title: 'first mission', instructions: 'instructions', duration: 10, category: 'category')
    Mission.create!(title: 'second mission', instructions: 'instructions', duration: 10, category: 'category')
    Mission.create!(title: 'third mission', instructions: 'instructions', duration: 10, category: 'category')

    visit 'http://localhost:3000/missions'

    expect(find_all('tbody tr').length).to eql(3)
  end

  scenario 'should delete the mission with destroy button' do
    Mission.create!(title: 'title', instructions: 'instructions', duration: 10, category: 'category')

    visit 'http://localhost:3000/missions'

    expect(find_all('tbody tr').length).to eql(1)

    page.accept_alert do
      click_link 'Destroy'
    end

    expect(find_all('tbody tr').length).to eql(0)
  end
end