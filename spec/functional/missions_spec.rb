# frozen_string_literal: true

require 'rails_helper'
require 'locale_helpers'

default_url = 'http://localhost:3001'

def fill_mission_form(mission_category, mission_duration, mission_instructions, mission_language, mission_title)
  fill_in 'mission_title', with: mission_title
  fill_in 'mission_instructions', with: mission_instructions
  fill_in 'mission_duration', with: mission_duration
  fill_in 'mission_category', with: mission_category
  fill_in 'mission_language', with: mission_language
end

feature 'Mission' do

  scenario 'should create successfully' do
    visit "#{default_url}/missions/new"

    fill_mission_form('Healthy',
                      '22',
                      'New Mission Description',
                      'en',
                      'New Mission')

    click_button 'Create Mission'

    expect(find('p#notice')).to have_text('Mission was successfully created.')
    expect(current_path).to eql('/missions/1')
  end

  scenario 'should edit successfully' do
    Mission.create!(title: 'title', instructions: 'instructions', duration: 10, category: 'category')

    visit "#{default_url}/missions/1/edit"

    fill_in 'mission_title', with: 'edited mission title'
    fill_in 'mission_instructions', with: 'edited mission title'

    click_button 'Update Mission'

    expect(find('p#notice')).to have_text('Mission was successfully updated.')
    expect(current_path).to eql('/missions/1')
  end

  scenario 'should show all missions when go to missions/' do
    reset_locale "en"
    Mission.create!(title: 'first mission', instructions: 'instructions', duration: 10, category: 'category')
    reset_locale "fr"
    Mission.create!(title: 'second mission', instructions: 'instructions', duration: 10, category: 'category')
    reset_locale "sp"
    Mission.create!(title: 'third mission', instructions: 'instructions', duration: 10, category: 'category')

    visit "#{default_url}/missions"

    expect(find_all('tbody tr').length).to eql(3)
  end

  scenario 'should delete the mission with destroy button' do
    Mission.create!(title: 'title', instructions: 'instructions', duration: 10, category: 'category')

    visit "#{default_url}/missions"

    expect(find_all('tbody tr').length).to eql(1)

    page.accept_alert do
      click_link 'Destroy'
    end

    expect(find_all('tbody tr').length).to eql(0)
  end

  xit 'Missions form should support creation of different language' do
    mission_title = 'مهمة جديدة'
    mission_instructions = 'وصف المهمة الجديدة'
    mission_duration = '22'
    mission_category = 'Healthy'
    mission_language =  'ar'

    visit "#{default_url}/missions/new"

    fill_mission_form(mission_category,
                      mission_duration,
                      mission_instructions,
                      mission_language,
                      mission_title)

    click_button 'Create Mission'

    expect(find('p#notice').text).to eql('Mission was successfully created.')
    expect(current_path).to eql('/missions/1')

    # check the created mission in form redirection show
    expect(find('body > p:nth-child(2)')).to have_text(mission_title)
    expect(find('body > p:nth-child(3)')).to have_text(mission_instructions)

    # validate the created mission in show all
    visit "#{default_url}/missions"

    expect(find_all('tbody tr').length).to eql(1)
    expect(find('tbody > tr:nth-child(1) > td:nth-child(1)')).to have_text(mission_title)
    expect(find('tbody > tr:nth-child(1) > td:nth-child(2)')).to have_text(mission_instructions)
  end

end