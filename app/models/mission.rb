# frozen_string_literal: true
require 'mission_helpers'
class Mission < ApplicationRecord
  include ActiveModel::Validations

  # TODO: set title and instructions independently of @after_create
  validates :duration, presence: true
  validates :category, presence: true

  after_create :add_info_to_locale
  after_update :add_info_to_locale

  #TODO check existence of mission id before adding or editing

  def title
    if id
      local_translation_tables = I18n.backend.send(:translations)[I18n.locale]
      all_missions = local_translation_tables[:missions]
      requested_mission = all_missions[generate_mission_id(id).to_sym]

      requested_mission[:title]
    else
      ''
    end
  end

  def instructions
    if id
      local_translation_tables = I18n.backend.send(:translations)[I18n.locale]
      all_missions = local_translation_tables[:missions]
      requested_mission = all_missions[generate_mission_id(id).to_sym]

      requested_mission[:instructions]
    else
      ''
    end
  end

  def title=(value)
    @mission_locale_title = value
  end

  def instructions=(value)
    @mission_locale_instructions = value
  end

  def add_info_to_locale
    yml_file_path = Rails.root.join("config/locales/#{I18n.locale}.yml")

    file_content = File.open(yml_file_path, 'r').read

    yml_file_content = YAML.load file_content

    missions = yml_file_content[I18n.locale.to_s]['missions']

    new_mission_info = {generate_mission_id(id)=> {title: @mission_locale_title, instructions: @mission_locale_instructions}}

    missions.merge!(new_mission_info)

    File.open(yml_file_path, 'w') do |file|
      file.write(yml_file_content.to_yaml)
    end
    reset_locale(I18n.locale)
  end
end
