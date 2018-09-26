# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AppController, type: :controller do
  render_views

  describe 'AppController Actions' do
    it 'Get#index returns http success' do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'POST#create should create a new yml file' do
      language_name = 'fr'
      hello_string = 'bonjour'
      file_path = Rails.root.join('config/locales', "#{language_name}.yml")

      post :create, params: {language_name: language_name, strings: {hello: hello_string}}

      expect(File.exists?(file_path))

      file_data = File.read(file_path)
      expect(file_data).to eql("fr:\n  our:\n    hello: \"bonjour\"")
    ensure
      File.delete(file_path)
    end
  end

  describe 'languageDictToArray' do
    it 'should extract dictionary to a flat array of key value pairs' do
      I18n.backend.send(:init_translations) unless I18n.backend.initialized?

      result = AppController.language_dict_to_array(:en)

      expect(result).to include('hello')
    end
  end
end
