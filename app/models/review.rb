class Review < ApplicationRecord
  # acts_as_tenant(:company)

  belongs_to :user
  belongs_to :product
  has_many_attached :images

  validates :rating, presence: true, inclusion: { in: 1..5 }
  validates :user_id, uniqueness: { scope: :product_id, message: "has already reviewed this product" }
  validate :images_count_within_limit

  private

  def images_count_within_limit
    return unless images.attached?

    if images.count > 3
      errors.add(:images, "cannot attach more than 3 images")
    end
  end
end
