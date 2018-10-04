require 'rails_helper'
require 'yaml'

def create_yml_file_for_locale_mission(yaml_path, main_language, id, title, instructions)
  File.open(yaml_path, "w+") do |file|
    file.write("#{main_language}:\n")
    file.write((' ' * 2) + "missions:\n")
    file.write((' ' * 4) + "#{id}:\n")
    file.write((' ' * 6) + "title: '#{title}'\n")
    file.write((' ' * 6) + "instructions: '#{instructions}'")
  end
end

RSpec.describe Mission, type: :model do
  before(:all) do
    I18n.locale = 'en'
  end

  xit 'validates presence of title' do
    record = Mission.new
    record.title = ''
    record.valid?
    expect(record.errors[:title]).to include('can\'t be blank')
  end

  it 'validates presence of instructions' do
    record = Mission.new
    record.instructions = ''
    record.valid?
    expect(record.errors[:instructions]).to include('can\'t be blank')
  end

  it 'validates presence of duration' do
    record = Mission.new
    record.duration = {}
    record.valid?
    expect(record.errors[:duration]).to include('can\'t be blank')
  end

  it 'validates presence of category' do
    record = Mission.new
    record.category = ''
    record.valid?
    expect(record.errors[:category]).to include('can\'t be blank')
  end

  it 'should save the model with id' do
    #create new mission
    record = Mission.new
    record.category = '96'
    record.duration = 10
    record.instructions = 'instructions'
    record.title = 'title'

    record.save

    expect(record.errors[:title].length).to eql(0)
    expect(record.errors[:instructions].length).to eql(0)
  end

  it 'reads the title correctly based on locale' do
    ar_title = "daght"
    en_title = "pushup"

    #create locale files
    en_yaml_path = Rails.root.join("config/locales/en_test.yml")
    create_yml_file_for_locale_mission(en_yaml_path,'en_test', 1, en_title, 'exercise')

    ar_yaml_path = Rails.root.join("config/locales/ar_test.yml")
    create_yml_file_for_locale_mission(ar_yaml_path,'ar_test', 1, ar_title, 'instaructions')

    I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    #create new mission
    record = Mission.new
    record.category = '96'
    record.duration = 10
    record.instructions = 'instructions'
    record.title = 'title'
    record.save


    #create en_test
    I18n.locale = "en_test"
    expect(record.title).to eql(en_title)

    I18n.locale = "ar_test"
    expect(record.title).to eql(ar_title)

  ensure
    File.delete(en_yaml_path) if File.exists?(en_yaml_path)
    File.delete(ar_yaml_path) if File.exists?(ar_yaml_path)
  end

end
