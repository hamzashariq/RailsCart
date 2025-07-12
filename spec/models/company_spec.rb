require 'rails_helper'

RSpec.describe Company, type: :model do
  let(:company) { create(:company) }

  subject { build(:company) }

  describe 'associations' do
    it { should have_many(:users).dependent(:destroy) }
    it { should have_many(:products).dependent(:destroy) }
    it { should have_many(:carts).dependent(:destroy) }
    it { should have_many(:orders).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:subdomain) }
    it { should validate_uniqueness_of(:subdomain).case_insensitive }
  end

  describe 'factory' do
    it 'creates a valid company' do
      expect(company).to be_valid
    end

    it 'creates companies with unique subdomains' do
      company1 = create(:company)
      company2 = create(:company)

      expect(company1.subdomain).not_to eq(company2.subdomain)
    end
  end
end
