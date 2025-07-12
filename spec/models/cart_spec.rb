require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:cart) { create(:cart, user: user, company: company) }

  describe 'associations' do
    it { should belong_to(:company) }
    it { should belong_to(:user).optional }
    it { should have_many(:carts_products).dependent(:destroy) }
  end

  describe 'instance methods' do
    describe '#total_items' do
      context 'when cart is empty' do
        it 'returns 0' do
          expect(cart.total_items).to eq(0)
        end
      end

      context 'when cart has items' do
        before do
          product1 = create(:product, company: company)
          product2 = create(:product, company: company)
          create(:carts_product, cart: cart, product: product1, quantity: 2)
          create(:carts_product, cart: cart, product: product2, quantity: 3)
        end

        it 'returns the sum of all quantities' do
          expect(cart.total_items).to eq(5)
        end
      end
    end

    describe '#total_price' do
      context 'when cart is empty' do
        it 'returns 0' do
          expect(cart.total_price).to eq(0)
        end
      end

      context 'when cart has items' do
        before do
          product1 = create(:product, company: company, price: 10.00)
          product2 = create(:product, company: company, price: 25.50)
          create(:carts_product, cart: cart, product: product1, quantity: 2)
          create(:carts_product, cart: cart, product: product2, quantity: 1)
        end

        it 'returns the total price of all items' do
          # (10.00 * 2) + (25.50 * 1) = 45.50
          expect(cart.total_price).to eq(45.50)
        end
      end

      context 'with multiple items and quantities' do
        before do
          product1 = create(:product, company: company, price: 15.99)
          product2 = create(:product, company: company, price: 8.50)
          product3 = create(:product, company: company, price: 100.00)
          create(:carts_product, cart: cart, product: product1, quantity: 3)
          create(:carts_product, cart: cart, product: product2, quantity: 2)
          create(:carts_product, cart: cart, product: product3, quantity: 1)
        end

        it 'calculates the correct total' do
          # (15.99 * 3) + (8.50 * 2) + (100.00 * 1) = 47.97 + 17.00 + 100.00 = 164.97
          expect(cart.total_price).to eq(164.97)
        end
      end
    end

    describe '#empty!' do
      before do
        product1 = create(:product, company: company)
        product2 = create(:product, company: company)
        create(:carts_product, cart: cart, product: product1, quantity: 2)
        create(:carts_product, cart: cart, product: product2, quantity: 3)
      end

      it 'removes all cart products' do
        expect(cart.carts_products.count).to eq(2)

        cart.empty!

        expect(cart.carts_products.count).to eq(0)
      end

      it 'destroys the cart product records' do
        cart_product_ids = cart.carts_products.pluck(:id)

        cart.empty!

        cart_product_ids.each do |id|
          expect(CartsProduct.find_by(id: id)).to be_nil
        end
      end
    end
  end

  describe 'class methods' do
    describe '.ransackable_attributes' do
      it 'returns the allowed searchable attributes' do
        expected_attributes = ["created_at", "id", "updated_at", "user_id"]
        expect(Cart.ransackable_attributes).to match_array(expected_attributes)
      end
    end

    describe '.ransackable_associations' do
      it 'returns the allowed searchable associations' do
        expected_associations = ["carts_products", "company", "user"]
        expect(Cart.ransackable_associations).to match_array(expected_associations)
      end
    end
  end

  describe 'acts_as_tenant' do
    it 'is scoped to company' do
      company1 = create(:company)
      company2 = create(:company)

      cart1 = create(:cart, company: company1)
      cart2 = create(:cart, company: company2)

      ActsAsTenant.with_tenant(company1) do
        expect(Cart.all).to include(cart1)
        expect(Cart.all).not_to include(cart2)
      end
    end
  end

  describe 'factory' do
    it 'creates a valid cart' do
      expect(cart).to be_valid
    end

    it 'creates a cart with products using trait' do
      cart_with_products = create(:cart_with_products, company: company)
      expect(cart_with_products.carts_products.count).to eq(3)
    end
  end
end
