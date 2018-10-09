require 'rails_helper'
require 'locale_helpers'
require 'mission_helpers'
require 'yaml'


describe 'Mission returns title and instructions by language' do

  it 'should save the model with id' do
    reset_locale 'en_test'
    record = Mission.create!({title: 'title', instructions: 'instructions', duration: 10, category: 'category'})

    expect(record.errors[:title].length).to eql(0)
    expect(record.errors[:instructions].length).to eql(0)
  end

  it 'should save the title to the locale' do
    reset_locale 'en_test'

    record = Mission.create!({title: 'demo_test_title', instructions: 'instructions', duration: 10, category: 'category'})

    yml_hash = YAML.load(File.read(yml_path('en_test')))
    en_missions_hash = yml_hash['en_test']['missions']
    mission = en_missions_hash[mission_id_to_locale_id(record.id)]
    expect(mission[:title]).to eql('demo_test_title')
  ensure
    remove_locale_file 'en_test'
  end

  it 'should save the instructions to the locale' do
    reset_locale 'en_test'

    record = Mission.create!({title: 'demo_test_title', instructions: 'go up and down', duration: 10, category: 'category'})

    yml_hash = YAML.load(File.read(yml_path('en_test')))
    expect(yml_hash['en_test']['missions'][mission_id_to_locale_id(record.id)][:instructions]).to eql('go up and down')
  ensure
    remove_locale_file 'en_test'
  end

  it 'reads the title correctly based on locale' do
    ar_title = 'daght'
    en_title = 'pushup'
    create_yml_file_for_locale_mission('ar_test', 1, ar_title, 'instructions')
    reset_locale 'en_test'

    record = Mission.create!({title: en_title, instructions: 'exercise', duration: 10, category: 'category'})

    reset_locale 'en_test'
    expect(record.title).to eql(en_title)
    reset_locale 'ar_test'
    expect(record.title).to eql(ar_title)
  ensure
    remove_locale_file 'en_test'
    remove_locale_file 'ar_test'
  end

  it 'reads the instructions correctly based on locale' do
    en_instructions = 'exercise'
    ar_instructions = 'tamarin'
    create_yml_file_for_locale_mission('ar_test', 1, 'ar_title', ar_instructions)
    reset_locale 'en_test'

    record = Mission.create!({title: 'en_title', instructions: en_instructions, duration: 10, category: 'category'})

    reset_locale 'en_test'
    expect(record.instructions).to eql(en_instructions)

    reset_locale 'ar_test'
    expect(record.instructions).to eql(ar_instructions)
  ensure
    remove_locale_file 'en_test'
    remove_locale_file 'ar_test'
  end

  it 'update title and instructions from locale ' do
    reset_locale 'en_test'
    record = Mission.create!({title: 'initial_title', instructions: 'initial_instruction', duration: 5, category: 'category'})
    record_to_be_updated = Mission.find(record.id)

    record_to_be_updated.title = "modified_title"
    record_to_be_updated.instructions = "modified_instructions"
    record_to_be_updated.save

    expect(record_to_be_updated.title).to eql('modified_title')
    expect(record_to_be_updated.instructions).to eql('modified_instructions')
  ensure
    remove_locale_file 'en_test'
  end


  it 'remove the mission from locale file after destroy the mission' do
    reset_locale 'en_test'
    mission = Mission.create!({title: 'initial_title', instructions: 'initial_instruction', duration: 5, category: 'category'})

    mission.destroy

    yml_hash = YAML.load(File.read(yml_path('en_test')))
    en_missions = yml_hash['en_test']['missions']
    expect(en_missions).not_to include(mission_id_to_locale_id(mission.id))

  ensure
    remove_locale_file 'en_test'
  end

  it 'remove  the mission from  all locales file after destroy the mission' do
    reset_locale 'en_test'
    mission = Mission.create!({title: 'initial_title', instructions: 'initial_instruction', duration: 5, category: 'category'})
    yml_hash_english = YAML.load(File.read(yml_path('en_test')))
    expect(yml_hash_english['en_test']['missions']).to include(mission_id_to_locale_id(mission.id))

    reset_locale 'ar_test'
    mission.title = 'new title arabic'
    mission.instructions = 'new arabic instructions'

    mission.save

    yml_hash_arabic = YAML.load(File.read(yml_path('ar_test')))
    expect(yml_hash_arabic['ar_test']['missions']).to include(mission_id_to_locale_id(mission.id))


    mission.destroy

    yml_hash_arabic = YAML.load(File.read(yml_path('ar_test')))
    expect(yml_hash_arabic['ar_test']['missions']).not_to include(mission_id_to_locale_id(mission.id))

    yml_hash_english = YAML.load(File.read(yml_path('en_test')))
    expect(yml_hash_english['en_test']['missions']).not_to include(mission_id_to_locale_id(mission.id))
  ensure
    remove_locale_file 'en_test'
    remove_locale_file 'ar_test'

  end
end