# frozen_string_literal: true

require 'rails_helper'

feature 'User adds a language', js: true do
  scenario 'fills form and adds a language' do
    visit 'localhost:3000'
    fill_in 'language_name', with: 'fr'

    fill_in 'strings.hello', with: 'bonjour'

    fill_in 'strings.kaka', with: 'merde'

    click_button 'add_language'

    expect(current_path).to eql('/app')

    file_path = Rails.root.join('config/locales', 'fr.yml')

    expect(File.exist?(file_path)).to be_truthy
  ensure
    File.delete(file_path) if File.exist? file_path
  end

  scenario 'retrieves locale correctly' do
    file_data = "fr:\n  our:\n    hello: \"bonjour\"\n    secondString: \"second\""
    file_path = Rails.root.join('config/locales', 'fr.yml')

    File.open(file_path, "w+") do |f|
      f.write(file_data)
    end

    I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    visit 'localhost:3000/?locale=fr'

    expect(find('h1').text).to eql('bonjour')
  ensure
    File.delete(file_path) if File.exist? file_path
  end
end
