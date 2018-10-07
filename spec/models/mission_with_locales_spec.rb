require 'rails_helper'
require 'yaml'


describe 'Mission returns title and instructions by language' do

  it 'should save the model with id' do
    # create new mission
    record = Mission.new
    record.category = '96'
    record.duration = 10
    record.instructions = 'instructions'
    record.title = 'title'
    record.save

    expect(record.errors[:title].length).to eql(0)
    expect(record.errors[:instructions].length).to eql(0)
  end

  it 'should save the title to the locale' do
    record = Mission.new
    record.category = '96'
    record.duration = 10
    record.title = 'demo_test_title'
    record.instructions = 'instructions'
    en_yml_path = Rails.root.join('config/locales/en_test.yml')
    create_base_yml_file_without_missions(en_yml_path, 'en_test')

    I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    I18n.locale = 'en_test'
    record.save

    yml_hash = YAML.load(File.read(en_yml_path))
    expect(yml_hash['en_test']['missions']["m_#{record.id.to_s}"][:title]).to eql('demo_test_title')
  ensure
    File.delete(en_yml_path) if File.exists? en_yml_path
  end

  it 'should save the instructions to the locale' do
    record = Mission.new
    record.category = '96'
    record.duration = 10
    record.title = 'demo_test_title'
    record.instructions = 'go up and down'
    en_yml_path = Rails.root.join('config/locales/en_test.yml')
    create_base_yml_file_without_missions(en_yml_path, 'en_test')

    I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    I18n.locale = 'en_test'
    record.save

    yml_hash = YAML.load(File.read(en_yml_path))
    expect(yml_hash['en_test']['missions']["m_#{record.id.to_s}"][:instructions]).to eql('go up and down')
  ensure
    File.delete(en_yml_path) if File.exists? en_yml_path
  end

  it 'reads the title correctly based on locale' do
    ar_title = 'daght'
    en_title = 'pushup'

    # create locale files
    en_yaml_path = Rails.root.join('config/locales/en_test.yml')
    create_yml_file_for_locale_mission(en_yaml_path, 'en_test', 1, en_title, 'exercise')

    ar_yaml_path = Rails.root.join('config/locales/ar_test.yml')
    create_yml_file_for_locale_mission(ar_yaml_path, 'ar_test', 1, ar_title, 'instaructions')

    I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # create new mission
    record = Mission.new
    record.category = '96'
    record.duration = 10
    record.save

    # create en_test
    I18n.locale = 'en_test'
    expect(record.title).to eql(en_title)

    I18n.locale = 'ar_test'
    expect(record.title).to eql(ar_title)

  ensure
    File.delete(en_yaml_path) if File.exist?(en_yaml_path)
    File.delete(ar_yaml_path) if File.exist?(ar_yaml_path)
  end

  it 'reads the instructions correctly based on locale' do
    ar_instructions = 'exercise'
    en_instructions = 'tamarin'

    # create locale files
    en_yaml_path = Rails.root.join('config/locales/en_test.yml')
    create_yml_file_for_locale_mission(en_yaml_path, 'en_test', 1, 'en_title', en_instructions)

    ar_yaml_path = Rails.root.join('config/locales/ar_test.yml')
    create_yml_file_for_locale_mission(ar_yaml_path, 'ar_test', 1, 'ar_title', ar_instructions)

    I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # create new mission
    record = Mission.new
    record.category = '96'
    record.duration = 10
    record.save

    # create en_test
    I18n.locale = 'en_test'
    expect(record.instructions).to eql(en_instructions)

    I18n.locale = 'ar_test'
    expect(record.instructions).to eql(ar_instructions)

  ensure
    File.delete(en_yaml_path) if File.exist?(en_yaml_path)
    File.delete(ar_yaml_path) if File.exist?(ar_yaml_path)
  end

  #todo remove duplication
  def create_base_yml_file_without_missions(yaml_path, main_language)
    File.open(yaml_path, 'w+') do |file|
      file.write("#{main_language}:\n")
      file.write((' ' * 2) + "missions:\n")
      file.write((' ' * 4) + "hello: \"Hello world!\"\n")

    end
  end

  def create_yml_file_for_locale_mission(yaml_path, main_language, id, title, instructions)
    File.open(yaml_path, 'w+') do |file|
      file.write("#{main_language}:\n")
      file.write((' ' * 2) + "missions:\n")
      file.write((' ' * 4) + "m_#{id}:\n")
      file.write((' ' * 6) + "title: '#{title}'\n")
      file.write((' ' * 6) + "instructions: '#{instructions}'")
    end
  end
end