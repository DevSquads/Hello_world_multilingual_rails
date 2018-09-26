# frozen_string_literal: true

class AppController < ApplicationController
  def index
    @dictKeys = AppController.language_dict_to_array(:en)
    render :index
  end

  def create
    yml_file_path = Rails.root.join('config/locales', "#{params[:language_name]}.yml")
    dict_hash = {}

    params.each do |param_key, value|
      if param_key.include? 'strings.'
        dict_key_name = param_key.sub 'strings.', ''
        dict_hash[dict_key_name] = value
      end
    end

    create_language_yml(dict_hash, yml_file_path)
  end

  def self.language_dict_to_array(lang)
    key_paths(nil, I18n.backend.send(:translations)[lang][:our] || {}).flatten.sort
  end

  def self.key_paths(key, hash_or_string)
    if hash_or_string.is_a?(Hash)
      hash_or_string.keys.map do |subkey|
        key_paths([key, subkey].compact.join('.'), hash_or_string[subkey])
      end
    else
      key
    end
  end

  private

  def create_language_yml(dict_hash, yml_file_path)
    File.open(yml_file_path, "w+") do |yml_file|
      yml_file.write("#{params[:language_name]}:\n")
      yml_file.write("  our:\n")

      line_number = 0
      dict_hash.each do |key, value|
        if not line_number == 0
          current_line = "\n"
        else
          current_line = ''
        end

        current_line += "    #{key}: \"#{value}\""
        yml_file.write(current_line)
        line_number += 1
      end
    end
  end
end
