# frozen_string_literal: true

# This model is non-standard
# Duration, category and ID are persisted in the database as per usual active records
# title and instructions are calculated by getting them from locale files depending on the
# current locale

require 'mission_helpers'
require 'locale_helpers'

class Mission < ApplicationRecord
  include ActiveModel::Validations

  #duration, category, title, and instruction cannot be null
  validates :duration, presence: true
  validates :category, presence: true
  validates :title, presence: true
  validates :instructions, presence: true


  after_create :add_info_to_locale
  after_update :add_info_to_locale
  after_destroy :clean_locale

  # Gets the title from locale if the record was previously saved
  # Or gets the title from the instance object
  def title
    if id
      # retrieves the current mission's entry from locale
      requested_mission = get_mission_from_locale

      if requested_mission
        requested_mission[:title]
      else
        "Mission is not supported in this language: #{I18n.locale}."
      end
    else
      @mission_locale_title
    end
  end

  # Gets the instructions from locale if the record was previously saved
  # Or gets the instructions from the instance object
  def instructions
    if id
      # retrieves the current mission's entry from locale
      requested_mission = get_mission_from_locale

      if requested_mission
        requested_mission[:instructions]
      else
        "Mission is not supported in this language: #{I18n.locale}."
      end
    else
      @mission_locale_instructions
    end
  end

  # Sets the title to an instance variable
  # So it can be later retrieved and written in the locale files
  def title=(value)
    @mission_locale_title = value
  end

  # Sets the instructions to an instance variable
  # So it can be later retrieved and written in the locale files
  def instructions=(value)
    @mission_locale_instructions = value
  end

  # Writes the mission's info to a local file whether after updating or creating the record
  def add_info_to_locale
    #load missions from the appropriate locale
    yml_file_path = yml_path I18n.locale
    file_content = File.open(yml_file_path, 'r').read
    yml_file_content = YAML.load file_content
    missions = yml_file_content[I18n.locale.to_s]['missions']

    # create a new mission object that is merged with the locale data (title and instructions)
    new_mission_info = {mission_id_to_locale_id(id) => {
        title: @mission_locale_title,
        instructions: @mission_locale_instructions
    }}
    missions.merge!(new_mission_info)

    #update the locale file by writing the missions hash back to the file
    File.open(yml_file_path, 'w') do |file|
      file.write(yml_file_content.to_yaml)
    end
    #reload the locale hash based on the new file content
    reset_locale(I18n.locale)
  end

  # Deletes a mission's locale entry on delete
  def clean_locale
    I18n.available_locales.each do |locale_language|
      yml_file_path = yml_path locale_language
      file_content = File.open(yml_file_path, 'r').read
      yml_file_content = YAML.load file_content
      missions = yml_file_content[locale_language.to_s]['missions']

      missions.delete(mission_id_to_locale_id(id))

      File.open(yml_file_path, 'w') do |file|
        file.write(yml_file_content.to_yaml)
      end
    end
  end

  private

  def get_mission_from_locale
    # retrieve all locales available in the current I18n translation tables
    local_translation_tables = I18n.backend.send(:translations)[I18n.locale]
    # retrieve missions scope from local table
    all_missions = local_translation_tables[:missions]
    # retrieve a specific mission
    all_missions[mission_id_to_locale_id(id).to_sym]
  end
end
