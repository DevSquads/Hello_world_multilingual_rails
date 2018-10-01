class Mission < ApplicationRecord
  include ActiveModel::Validations

  validates :title, presence: true
  validates :instructions, presence: true
  validates :duration, presence: true
  validates :category, presence: true

end
