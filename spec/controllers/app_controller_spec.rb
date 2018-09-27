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

      post :create, params: {language_name: language_name, 'strings.hello': hello_string}

      expect(File.exists?(file_path))

      file_data = File.read(file_path)
      expect(file_data).to eql("fr:\n  our:\n    hello: \"bonjour\"")
      expect(response.status).to eql(200)
    ensure
      File.delete(file_path) if File.exist? file_path
    end

    it 'POST#create should create a new yml file with newlines between different string' do
      language_name = 'fr'
      hello_string = 'bonjour'
      file_path = Rails.root.join('config/locales', "#{language_name}.yml")

      post :create, params: {language_name: language_name, 'strings.hello': hello_string, 'strings.secondString': 'second'}

      expect(File.exists?(file_path))

      file_data = File.read(file_path)
      expect(file_data).to eql("fr:\n  our:\n    hello: \"bonjour\"\n    secondString: \"second\"")
      expect(response.status).to eql(200)
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

      result = AppController.language_dict_to_array(:en)

      expect(result).to include('hello')
    end
  end
end
