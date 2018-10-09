# frozen_string_literal: true

require 'mission_helpers'
require 'locale_helpers'

class Mission < ApplicationRecord
  include ActiveModel::Validations

  # TODO: set title and instructions independently of @after_create
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
    yml_file_path = Rails.root.join("config/locales/#{I18n.locale}.yml")

    file_content = File.open(yml_file_path, 'r').read

    yml_file_content = YAML.load file_content

    missions = yml_file_content[I18n.locale.to_s]['missions']

    # Info to be written
    new_mission_info = {mission_id_to_locale_id(id) => {
        title: @mission_locale_title,
        instructions: @mission_locale_instructions
    }}

    # Merges the new/updated mission to the retrieved yaml content to be written
    missions.merge!(new_mission_info)

    File.open(yml_file_path, 'w') do |file|
      file.write(yml_file_content.to_yaml)
    end
    reset_locale(I18n.locale)
  end

  # Deletes a mission's locale entry on delete
  def clean_locale
    I18n.available_locales.each do |locale_language|
      yml_file_path = Rails.root.join("config/locales/#{locale_language}.yml")
      file_content = File.open(yml_file_path, 'r').read
      yml_file_content = YAML.load file_content
      missions = yml_file_content[locale_language.to_s]['missions']
      missions.delete('m_1')

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
