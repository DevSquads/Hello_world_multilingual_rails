# frozen_string_literal: true

class Mission < ApplicationRecord
  include ActiveModel::Validations
  # TODO: set title and instructions independently of @after_create
  validates :duration, presence: true
  validates :category, presence: true

  after_create :write_title_to_yml_file

  #TODO check existence of mission id before adding or editing

  def title
    if id
      I18n.backend.send(:translations)[I18n.locale][:missions][id][:title]
    else
      'placeholder_title'
    end
  end

  def instructions
    if id
      I18n.backend.send(:translations)[I18n.locale][:missions][id][:instructions]
    else
      'placeholder_instructions'
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
  end
end
