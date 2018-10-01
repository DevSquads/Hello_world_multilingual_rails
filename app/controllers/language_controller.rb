# frozen_string_literal: true

class LanguageController < ApplicationController

  @@custom_locale_domain = :missions

  def index
    @key_array = LanguageController.language_dict_to_keys_array(:en)
    render :index
  end

  def create
    params.require(:language_name)

    request_locales_data = {}
    params.each do |param_key, value|
      if param_key.include? 'strings.'
        dict_key_name = param_key.sub 'strings.', ''
        request_locales_data[dict_key_name] = value
      end
    end

    write_language_to_yml_file(request_locales_data)
    render status: :ok
  rescue ActionController::ParameterMissing
    render status: :bad_request
  end

  def self.language_dict_to_keys_array(lang)
    locale_dictionary = I18n.backend.send(:translations)[lang][@@custom_locale_domain] || {}
    extract_keys_from_dict(locale_dictionary)
  end

  def self.extract_keys_from_dict(dictionary)
    keys = []
    dictionary.each do |key, value|
      keys.push(key)
    end
    return keys
  end

  private

  def write_language_to_yml_file(locales_dict)
    yml_file_path = Rails.root.join('config/locales', "#{params[:language_name]}.yml")

    File.open(yml_file_path, 'w+') do |yml_file|
      yml_file.write("#{params[:language_name]}:\n")
      yml_file.write("  #{@@custom_locale_domain}:\n")

      line_number = 0
      four_spaces = "    "
      current_line = ""
      locales_dict.each do |key, value|
        current_line = "\n" if line_number != 0
        current_line += four_spaces + "#{key}: \"#{value}\""

        yml_file.write(current_line)
        line_number += 1
      end
    end
  end
end
