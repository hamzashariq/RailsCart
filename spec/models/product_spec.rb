require 'rails_helper'

RSpec.describe Product, type: :model do
  let(:company) { create(:company) }
  let(:product) { create(:product, company: company) }

  describe 'associations' do
    it { should belong_to(:company) }
    it { should have_many(:carts_products).dependent(:destroy) }
    it { should have_many(:reviews).dependent(:destroy) }
    it { should have_one_attached(:image) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(product).to be_valid
    end

    # Note: The Product model doesn't have explicit validations,
    # but we can test that it accepts valid data
    it 'accepts valid name' do
      product.name = 'Test Product'
      expect(product).to be_valid
    end

    it 'accepts valid price' do
      product.price = 10.99
      expect(product).to be_valid
    end

    it 'accepts valid stock' do
      product.stock = 100
      expect(product).to be_valid
    end
  end

  describe 'instance methods' do
    describe '#average_rating' do
      context 'when product has no reviews' do
        it 'returns 0' do
          expect(product.average_rating).to eq(0)
        end
      end

      context 'when product has reviews' do
        before do
          create(:review, product: product, rating: 5)
          create(:review, product: product, rating: 3)
          create(:review, product: product, rating: 4)
        end

        it 'returns the average rating' do
          expect(product.average_rating).to eq(4.0)
        end
      end

      context 'when product has one review' do
        before do
          create(:review, product: product, rating: 3)
        end

        it 'returns the single rating' do
          expect(product.average_rating).to eq(3.0)
        end
      end
    end
  end

  describe 'class methods' do
    describe '.ransackable_attributes' do
      it 'returns the allowed searchable attributes' do
        expected_attributes = ["created_at", "id", "name", "price", "stock", "updated_at"]
        expect(Product.ransackable_attributes).to match_array(expected_attributes)
      end
    end

    describe '.ransackable_associations' do
      it 'returns the allowed searchable associations' do
        expected_associations = ["company", "carts_products", "reviews"]
        expect(Product.ransackable_associations).to match_array(expected_associations)
      end
    end
  end

  describe 'acts_as_tenant' do
    it 'is scoped to company' do
      company1 = create(:company)
      company2 = create(:company)

      product1 = create(:product, company: company1)
      product2 = create(:product, company: company2)

      ActsAsTenant.with_tenant(company1) do
        expect(Product.all).to include(product1)
        expect(Product.all).not_to include(product2)
      end
    end
  end

  describe 'factory' do
    it 'creates valid products with different traits' do
      expect(create(:expensive_product)).to be_valid
      expect(create(:cheap_product)).to be_valid
      expect(create(:out_of_stock_product)).to be_valid
    end

    it 'creates products with correct trait attributes' do
      expensive = create(:expensive_product)
      cheap = create(:cheap_product)
      out_of_stock = create(:out_of_stock_product)

      expect(expensive.price).to be >= 500.0
      expect(cheap.price).to be <= 20.0
      expect(out_of_stock.stock).to eq(0)
    end
  end
end
