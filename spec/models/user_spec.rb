require 'rails_helper'

RSpec.describe User, type: :model do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }

  subject { build(:user, company: company) }

  describe 'associations' do
    it { should belong_to(:company) }
    it { should have_one(:cart).dependent(:destroy) }
    it { should have_many(:orders).dependent(:destroy) }
    it { should have_one_attached(:avatar) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_length_of(:first_name).is_at_most(50) }
    it { should validate_presence_of(:last_name) }
    it { should validate_length_of(:last_name).is_at_most(50) }
    it { should validate_presence_of(:user_type) }
    it { should validate_inclusion_of(:user_type).in_array(%w[admin customer]) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe 'devise modules' do
    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:encrypted_password) }
  end

  describe 'callbacks' do
    describe 'after_create_commit' do
      it 'creates a cart for the user' do
        expect { user }.to change(Cart, :count).by(1)
        expect(user.cart).to be_present
        expect(user.cart.company).to eq(company)
      end

      it 'does not create a cart if one already exists' do
        user_with_cart = create(:user, company: company)
        existing_cart = user_with_cart.cart

        # Simulate an update that would trigger the callback
        user_with_cart.update(first_name: 'New Name')

        expect(user_with_cart.reload.cart).to eq(existing_cart)
      end
    end
  end

  describe 'instance methods' do
    describe '#name' do
      it 'returns the full name' do
        user = create(:user, first_name: 'John', last_name: 'Doe')
        expect(user.name).to eq('John Doe')
      end
    end

    describe '#admin?' do
      it 'returns true for admin users' do
        admin = create(:admin_user)
        expect(admin.admin?).to be true
      end

      it 'returns false for customer users' do
        customer = create(:customer_user)
        expect(customer.admin?).to be false
      end
    end

    describe '#customer?' do
      it 'returns true for customer users' do
        customer = create(:customer_user)
        expect(customer.customer?).to be true
      end

      it 'returns false for admin users' do
        admin = create(:admin_user)
        expect(admin.customer?).to be false
      end
    end
  end

  describe 'class methods' do
    describe '.ransackable_attributes' do
      it 'returns the allowed searchable attributes' do
        expected_attributes = ["created_at", "email", "first_name", "id", "last_name", "updated_at", "user_type"]
        expect(User.ransackable_attributes).to match_array(expected_attributes)
      end
    end

    describe '.ransackable_associations' do
      it 'returns the allowed searchable associations' do
        expected_associations = ["cart", "company"]
        expect(User.ransackable_associations).to match_array(expected_associations)
      end
    end
  end

  describe 'acts_as_tenant' do
    it 'is scoped to company' do
      company1 = create(:company)
      company2 = create(:company)

      user1 = create(:user, company: company1)
      user2 = create(:user, company: company2)

      ActsAsTenant.with_tenant(company1) do
        expect(User.all).to include(user1)
        expect(User.all).not_to include(user2)
      end
    end
  end
end
