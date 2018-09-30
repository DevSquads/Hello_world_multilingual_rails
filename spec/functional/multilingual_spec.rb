# frozen_string_literal: true

require 'rails_helper'

feature 'User adds a language', js: true do
  scenario 'window size is large enough for tests' do
    visit 'http://localhost:3000'
    expect(current_window.size).to eql([1024, 768])
  end

  scenario 'testing that capybara can find any element' do
    visit 'https://google.com'

    expect(find('input[name="btnK"]')).to be_truthy
  end

  scenario 'testing that a dom is rendered' do
    visit 'http://localhost:3000'

    expect(html).to match('language_name')
  end

  scenario 'fills form and adds a language' do
    visit 'http://localhost:3000'

    fill_in 'language_name', with: 'fr'

    fill_in 'strings.hello', with: 'bonjour'

    fill_in 'strings.kaka', with: 'merde'

    click_button 'add_language'

    expect(current_path).to eql('/language')

    file_path = Rails.root.join('config/locales', 'fr.yml')

    expect(File.exist?(file_path)).to be_truthy
  ensure
    I18n.locale = I18n.default_locale
    File.delete(file_path) if (file_path != nil and File.exist? file_path)
  end

  scenario 'retrieves locale correctly' do
    file_data = "fr:\n  our:\n    hello: \"bonjour\"\n    secondString: \"second\""
    file_path = Rails.root.join('config/locales', 'fr.yml')

    File.open(file_path, "w+") do |f|
      f.write(file_data)
    end

    I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    visit 'http://localhost:3000/?locale=fr'

    expect(find('h1').text).to eql('bonjour')
  ensure
    I18n.locale = I18n.default_locale
    File.delete(file_path) if File.exist? file_path
  end
end
