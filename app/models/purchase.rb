class Purchase < ApplicationRecord
  belongs_to :user

  scope :completed, -> { where(completed: true) }
  scope :not_refunded, -> { where(refunded: false) }
  scope :have_income, -> { where(refunded: false) }
end
