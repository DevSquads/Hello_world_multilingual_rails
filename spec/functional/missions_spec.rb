# frozen_string_literal: true

require 'rails_helper'
require 'locale_helpers'




feature 'Mission' do
  default_url = 'http://localhost:3001'
  en_test_locale = 'en_test'

  scenario 'should create successfully' do
    mission_title = 'New Mission'
    mission_instructions = 'New Mission Description'
    mission_duration = 22
    mission_category = 'Healthy'

    create_mission_with_form(default_url, mission_title, mission_instructions,
                             mission_duration, mission_category, en_test_locale)

    expect(find('p#notice')).to have_text('Mission was successfully created.')
    expect(current_path).to eql('/')

    new_mission = Mission.find(1)
    expect(new_mission.category).to eql(mission_category)
    expect(new_mission.duration).to eql(mission_duration)

    reset_locale(en_test_locale)
    expect(new_mission.title).to eql(mission_title)
    expect(new_mission.instructions).to eql(mission_instructions)

    reset_locale('en')
    expect(new_mission.title).to eql('Mission is not supported in this language: en.')
    expect(new_mission.instructions).to eql('Mission is not supported in this language: en.')

    check_missions_table(mission_title,
                         mission_instructions,
                         'Mission was successfully created.')
  ensure
    remove_locale_file en_test_locale
  end

  scenario 'should edit successfully' do
    reset_locale en_test_locale
    Mission.create!(title: 'title', instructions: 'instructions', duration: 10, category: 'category')

    visit "#{default_url}/missions/1/edit"
    fill_in 'mission_title', with: 'edited mission title'
    fill_in 'mission_instructions', with: 'edited mission instructions'
    fill_in 'mission_language', with: en_test_locale
    click_button 'Update Mission'

    check_missions_table('edited mission title',
                         'edited mission instructions',
                         'Mission was successfully updated.')
  ensure
    remove_locale_file en_test_locale
  end

  scenario 'should show all missions when go to missions' do
    reset_locale en_test_locale
    Mission.create!(title: 'first mission', instructions: 'instructions', duration: 10, category: 'category')
    reset_locale 'fr_test'
    Mission.create!(title: 'second mission', instructions: 'instructions', duration: 10, category: 'category')
    reset_locale 'sp_test'
    Mission.create!(title: 'third mission', instructions: 'instructions', duration: 10, category: 'category')

    visit "#{default_url}/missions"

    expect(find_all('tbody tr').length).to eql(3)
  ensure
    remove_locale_file en_test_locale
    remove_locale_file 'fr_test'
    remove_locale_file 'sp_test'
  end

  scenario 'should delete the mission with destroy button' do
    reset_locale en_test_locale
    Mission.create!(title: 'title', instructions: 'instructions', duration: 10, category: 'category')
    visit "#{default_url}/missions"

    page.accept_alert do
      click_link 'Destroy'
    end

    expect(find_all('tbody tr').length).to eql(0)
  ensure
    remove_locale_file en_test_locale
  end

  scenario 'Missions form should support creation of different language' do
    mission_title = 'مهمة جديدة'
    mission_instructions = 'وصف المهمة الجديدة'
    mission_duration = 22
    mission_category = 'Healthy'
    mission_language = 'ar_test'

    create_mission_with_form(default_url, mission_title, mission_instructions, mission_duration, mission_category, mission_language)

    check_missions_table(mission_title, mission_instructions, 'Mission was successfully created.')
  ensure
    remove_locale_file 'ar_test'
  end

  scenario 'Homepage takes you to creating a new mission /missions/new' do
    visit default_url

    expect(find_all('h1#homepage_title').length).to eql(1)
    expect(find('h1#homepage_title')).to have_text("Admin")

    expect(find_all('h3#create_mission_title').length).to eql(1)
    expect(find('h3#create_mission_title')).to have_text("Create New Mission")
  end

  scenario 'The drop list adds a new language when adding a mission with a previously unsupported langauge' do
    create_mission_with_form(default_url,
                             'unsupported_title',
                             'unsupported_instructions',
                             11,
                             'unsupported_category',
                             'unsupported_language')
    available_languages = find_all('#languages option')

    expect(available_languages.last.value).to eql('unsupported_language')
  ensure
    remove_locale_file 'unsupported_language'
  end

  def fill_mission_form(mission_title, mission_instructions, mission_duration, mission_category, mission_language)
    fill_in 'mission_title', with: mission_title
    fill_in 'mission_instructions', with: mission_instructions
    fill_in 'mission_duration', with: mission_duration
    fill_in 'mission_category', with: mission_category
    fill_in 'mission_language', with: mission_language
  end

  def check_missions_table(mission_title, mission_instructions, notice)
    expect(find('p#notice').text).to eql(notice)
    expect(current_path).to eql('/')

    expect(find('.missions_table')).to be_truthy
    expect(find_all('.missions_table_row').length).to eql(1)

    expect(find('.missions_table_row .mission_title')).to have_text(mission_title)
    expect(find('.missions_table_row .mission_instructions')).to have_text(mission_instructions)
  end

  def create_mission_with_form(url, mission_title, mission_instructions,
                               mission_duration, mission_category, mission_language)
    visit url

    fill_mission_form(mission_title,
                      mission_instructions,
                      mission_duration,
                      mission_category,
                      mission_language)

    click_button 'Create Mission'
  end
end

