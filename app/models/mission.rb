# frozen_string_literal: true

class Mission < ApplicationRecord
  include ActiveModel::Validations
  # TODO: set title and instructions independently of @after_create
  validates :duration, presence: true
  validates :category, presence: true

  after_create :write_title_to_yml_file
  after_update :write_title_to_yml_file

  #TODO check existence of mission id before adding or editing

  def title
    if id
      trans = I18n.backend.send(:translations)
      missions = trans[I18n.locale][:missions]
      single_mission = missions["m_#{id}".to_sym]
      title = single_mission[:title]
    else
      ''
    end
  end

  def instructions
    if id
      I18n.backend.send(:translations)[I18n.locale][:missions]["m_#{id}".to_sym][:instructions]
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

  def write_title_to_yml_file
    yml_file_path = Rails.root.join("config/locales/#{I18n.locale}.yml")

    file_content = File.open(yml_file_path, 'r').read

    yml_file_content = YAML.load file_content

    yml_file_content[I18n.locale.to_s]['missions'].merge!({"m_#{self.id.to_s}" => {title: @mission_locale_title, instructions: @mission_locale_instructions}})

    File.open(yml_file_path, 'w') do |file|
      file.write(yml_file_content.to_yaml)
    end
    reset_locale(I18n.locale)
  end
end
