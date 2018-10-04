class Mission < ApplicationRecord
  include ActiveModel::Validations

  validates :duration, presence: true
  validates :category, presence: true
  validates :title, presence: true
  validates :instructions, presence: true

  def title
    if self.id
      I18n.backend.send(:translations)[I18n.locale][:missions][self.id][:title]
    else
      'placeholder_title'
    end
  end
end
