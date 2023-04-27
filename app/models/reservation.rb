class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :item

  validates :user, presence: true
  validates :item, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :start_date_before_end_date
  validate :item_not_reserved, on: :create

  private

  def start_date_before_end_date
    return unless start_date && end_date && start_date >= end_date

    errors.add(:start_date, 'must be before end date')
  end

  def item_not_reserved
    return unless item

    if item.reservations.exists?([
                                   'end_date >= ? AND start_date <= ?',
                                   start_date, end_date
                                 ])
      errors.add(:item, 'is already reserved for this period')
    end
  end
end
