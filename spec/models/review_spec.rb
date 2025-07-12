require 'rails_helper'

RSpec.describe Review, type: :model do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:product) { create(:product, company: company) }
  let(:review) { create(:review, user: user, product: product) }

  subject { build(:review, user: user, product: product) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:product) }
    it { should have_many_attached(:images) }
  end

  describe 'validations' do
    it { should validate_presence_of(:rating) }
    it { should validate_inclusion_of(:rating).in_range(1..5) }

    it 'validates uniqueness of user scoped to product' do
      create(:review, user: user, product: product)
      duplicate_review = build(:review, user: user, product: product)

      expect(duplicate_review).not_to be_valid
      expect(duplicate_review.errors[:user_id]).to include('has already reviewed this product')
    end

    it 'allows the same user to review different products' do
      product2 = create(:product, company: company)

      create(:review, user: user, product: product)
      review2 = build(:review, user: user, product: product2)

      expect(review2).to be_valid
    end

    it 'allows different users to review the same product' do
      user2 = create(:user, company: company)

      create(:review, user: user, product: product)
      review2 = build(:review, user: user2, product: product)

      expect(review2).to be_valid
    end

    describe 'images validation' do
      it 'allows up to 3 images' do
        review = build(:review)
        # Simulate attaching 3 images
        allow(review.images).to receive(:attached?).and_return(true)
        allow(review.images).to receive(:count).and_return(3)

        expect(review).to be_valid
      end

      it 'rejects more than 3 images' do
        review = build(:review)
        # Simulate attaching 4 images
        allow(review.images).to receive(:attached?).and_return(true)
        allow(review.images).to receive(:count).and_return(4)

        expect(review).not_to be_valid
        expect(review.errors[:images]).to include('cannot attach more than 3 images')
      end
    end
  end

  describe 'rating constraints' do
    it 'accepts valid ratings' do
      (1..5).each do |rating|
        review = build(:review, rating: rating)
        expect(review).to be_valid
      end
    end

    it 'rejects invalid ratings' do
      [0, 6, -1, 10].each do |invalid_rating|
        review = build(:review, rating: invalid_rating)
        expect(review).not_to be_valid
      end
    end
  end

  describe 'factory traits' do
    it 'creates reviews with different rating traits' do
      excellent = create(:excellent_review)
      good = create(:good_review)
      average = create(:average_review)
      poor = create(:poor_review)
      terrible = create(:terrible_review)

      expect(excellent.rating).to eq(5)
      expect(good.rating).to eq(4)
      expect(average.rating).to eq(3)
      expect(poor.rating).to eq(2)
      expect(terrible.rating).to eq(1)
    end

    it 'has appropriate descriptions for each trait' do
      excellent = create(:excellent_review)
      terrible = create(:terrible_review)

      expect(excellent.description).to include('Excellent')
      expect(terrible.description).to include('Terrible')
    end
  end

  describe 'impact on product average rating' do
    it 'affects the product average rating calculation' do
      product = create(:product)

      expect(product.average_rating).to eq(0)

      create(:review, product: product, rating: 4)
      expect(product.reload.average_rating).to eq(4.0)

      create(:review, product: product, rating: 2)
      expect(product.reload.average_rating).to eq(3.0)
    end
  end
end
