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
                      'en_test',
                      'New Mission')

    click_button 'Create Mission'

    expect(find('p#notice')).to have_text('Mission was successfully created.')
    expect(current_path).to eql('/')

    new_mission = Mission.find(1)
    expect(new_mission.category).to eql('Healthy')
    expect(new_mission.duration).to eql(22)
    reset_locale('en_test')
    expect(new_mission.title).to eql('New Mission')
    expect(new_mission.instructions).to eql('New Mission Description')

  ensure
    remove_locale_file 'en_test'
  end

  scenario 'should edit successfully' do
    reset_locale 'en_test'
    Mission.create!(title: 'title', instructions: 'instructions', duration: 10, category: 'category')

    visit "#{default_url}/missions/1/edit"

    fill_in 'mission_title', with: 'edited mission title'
    fill_in 'mission_instructions', with: 'edited mission title'
    fill_in 'mission_language', with: 'en_test'

    click_button 'Update Mission'

    expect(find('p#notice')).to have_text('Mission was successfully updated.')
    expect(current_path).to eql('/missions/1')
  ensure
    remove_locale_file 'en_test'
  end

  scenario 'should show all missions when go to missions' do
    reset_locale 'en_test'
    Mission.create!(title: 'first mission', instructions: 'instructions', duration: 10, category: 'category')
    reset_locale 'fr_test'
    Mission.create!(title: 'second mission', instructions: 'instructions', duration: 10, category: 'category')
    reset_locale 'sp_test'
    Mission.create!(title: 'third mission', instructions: 'instructions', duration: 10, category: 'category')

    visit "#{default_url}/missions"

    expect(find_all('tbody tr').length).to eql(3)
  ensure
    remove_locale_file 'en_test'
    remove_locale_file 'fr_test'
    remove_locale_file 'sp_test'
  end

  scenario 'should delete the mission with destroy button' do
    reset_locale 'en_test'
    Mission.create!(title: 'title', instructions: 'instructions', duration: 10, category: 'category')

    visit "#{default_url}/missions"

    expect(find_all('tbody tr').length).to eql(1)

    page.accept_alert do
      click_link 'Destroy'
    end

    expect(find_all('tbody tr').length).to eql(0)

  ensure
    remove_locale_file 'en_test'
  end

  scenario 'Missions form should support creation of different language' do
    mission_title = 'مهمة جديدة'
    mission_instructions = 'وصف المهمة الجديدة'
    mission_duration = '22'
    mission_category = 'Healthy'
    mission_language = 'ar_test'

    visit "#{default_url}"

    fill_mission_form(mission_category,
                      mission_duration,
                      mission_instructions,
                      mission_language,
                      mission_title)

    click_button 'Create Mission'

    expect(find('p#notice').text).to eql('Mission was successfully created.')
    expect(current_path).to eql('/')

    expect(find('.missions_table')).to be_truthy
    expect(find_all('.missions_table_row').length).to eql(1)

    expect(find('.missions_table_row .mission_title')).to have_text(mission_title)
    expect(find('.missions_table_row .mission_instructions')).to have_text(mission_instructions)
  ensure
    remove_locale_file 'ar_test'
  end

  scenario 'Homepage takes you to creating a new mission /missions/new' do
    visit "#{default_url}"
    expect(find_all('h1#homepage_title').length).to eql(1)
    expect(find('h1#homepage_title')).to have_text("Admin")

    expect(find_all('h3#create_mission_title').length).to eql(1)
    expect(find('h3#create_mission_title')).to have_text("Create New Mission")
  end

  #todo test that the drop list adds a new language when adding a mission with a previously unsupported language

end