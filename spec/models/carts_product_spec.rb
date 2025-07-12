require 'rails_helper'

RSpec.describe CartsProduct, type: :model do
  let(:company) { create(:company) }
  let(:cart) { create(:cart, company: company) }
  let(:product) { create(:product, company: company) }
  let(:carts_product) { create(:carts_product, cart: cart, product: product) }

  subject { build(:carts_product, cart: cart, product: product) }

  describe 'associations' do
    it { should belong_to(:cart) }
    it { should belong_to(:product) }
  end

  describe 'validations' do
    # Note: The CartsProduct model doesn't have explicit validations,
    # but we can test that it accepts valid data
    it 'is valid with valid attributes' do
      expect(carts_product).to be_valid
    end

    it 'accepts valid quantity' do
      carts_product.quantity = 5
      expect(carts_product).to be_valid
    end
  end

  describe 'factory' do
    it 'creates a valid carts_product' do
      expect(carts_product).to be_valid
    end

    it 'creates carts_product with large quantity trait' do
      large_quantity = create(:carts_product, :large_quantity)
      expect(large_quantity.quantity).to be >= 10
    end
  end
end
