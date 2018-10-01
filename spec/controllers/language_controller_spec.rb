# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LanguageController, type: :controller do
  render_views

  describe 'LanguageController Actions' do
    it 'Get#index returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'POST#create should create a new yml file' do
      file_path, hello_string, language_name = setup_french_locale

      post :create, params: {language_name: language_name, 'strings.hello': hello_string}

      verify_file_content(file_path, "fr:\n  our:\n    hello: \"bonjour\"")
    ensure
      File.delete(file_path) if File.exist? file_path
    end

    it 'POST#create should create a new yml file with newlines between different strings' do
      file_path, hello_string, language_name = setup_french_locale

      post :create, params: {language_name: language_name, 'strings.hello': hello_string, 'strings.secondString': 'second'}

      verify_file_content(file_path, "fr:\n  our:\n    hello: \"bonjour\"\n    secondString: \"second\"")
    ensure
      File.delete(file_path) if File.exist? file_path
    end

    it 'POST#create requires language name field' do
      post :create, params: {'strings.hello': 'hello_string', 'strings.secondString': 'second'}

      expect(response.status).to eql(400)
    end
  end

  describe 'languageDictToArray' do
    it 'should extract dictionary to a flat array of key value pairs' do
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?

      result = LanguageController.language_dict_to_keys_array(:en)

      expect(result).to include(:hello)
    end


    it 'locale_keys should get keys from dictionary ' do
      locale = { :hello => "hellloWorld", :goodBye => "Good Bye"}

      expect(LanguageController.extract_keys_from_dict(locale)).to match([:hello, :goodBye])
    end
  end
end

def verify_file_content(file_path, content)
  expect(File.exists?(file_path))

  file_data = File.read(file_path)
  expect(file_data).to eql(content)
  expect(response.status).to eql(200)
end

def setup_french_locale
  language_name = 'fr'
  hello_string = 'bonjour'
  file_path = Rails.root.join('config/locales', "#{language_name}.yml")
  return file_path, hello_string, language_name
end