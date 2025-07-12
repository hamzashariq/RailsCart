require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:order) { create(:order, user: user, company: company) }

  describe 'associations' do
    it { should belong_to(:company) }
    it { should belong_to(:user) }
    it { should have_one(:delivery_information) }
    it { should have_many(:product_snapshots) }
    it { should have_many(:order_histories).dependent(:destroy) }
    it { should accept_nested_attributes_for(:delivery_information) }
  end

  describe 'enums' do
    it 'defines delivery_status enum' do
      expect(Order.delivery_statuses).to eq({
        'pending' => 0,
        'confirmed' => 1,
        'shipped' => 2,
        'delivered' => 3,
        'cancelled' => 4
      })
    end

    it 'has correct enum methods' do
      expect(order).to respond_to(:pending?)
      expect(order).to respond_to(:confirmed?)
      expect(order).to respond_to(:shipped?)
      expect(order).to respond_to(:delivered?)
      expect(order).to respond_to(:cancelled?)
    end
  end

  describe 'callbacks' do
    describe 'after_create' do
      it 'creates an initial order history' do
        new_order = build(:order, user: user, company: company)

        expect { new_order.save! }.to change(OrderHistory, :count).by(1)

        history = new_order.order_histories.first
        expect(history.note).to eq('Order placed')
        expect(history.status_to).to eq('pending')
        expect(history.status_from).to be_nil
      end
    end

    describe 'after_update' do
      context 'when delivery_status changes' do
        it 'creates a status change history' do
          expect { order.update!(delivery_status: :confirmed) }
            .to change(order.order_histories, :count).by(1)

          history = order.order_histories.last
          expect(history.note).to eq('Order status changed from pending to confirmed')
          expect(history.status_from).to eq('pending')
          expect(history.status_to).to eq('confirmed')
        end

        it 'tracks multiple status changes' do
          order.update!(delivery_status: :confirmed)
          order.update!(delivery_status: :shipped)
          order.update!(delivery_status: :delivered)

          expect(order.order_histories.count).to eq(4) # initial + 3 changes

          histories = order.order_histories.order(:created_at)
          expect(histories[1].status_to).to eq('confirmed')
          expect(histories[2].status_to).to eq('shipped')
          expect(histories[3].status_to).to eq('delivered')
        end
      end

      context 'when other attributes change' do
        it 'does not create a history record' do
          expect { order.update!(updated_at: Time.current) }
            .not_to change(order.order_histories, :count)
        end
      end
    end
  end

  describe 'instance methods' do
    describe '#total' do
      context 'when order has no product snapshots' do
        it 'returns 0' do
          expect(order.total).to eq(0)
        end
      end

      context 'when order has product snapshots' do
        before do
          create(:product_snapshot, order: order, price: 10.00)
          create(:product_snapshot, order: order, price: 25.50)
          create(:product_snapshot, order: order, price: 5.99)
        end

        it 'returns the sum of all product snapshot prices' do
          expect(order.total).to eq(41.49)
        end
      end
    end
  end

  describe 'class methods' do
    describe '.ransackable_attributes' do
      it 'returns the allowed searchable attributes' do
        expected_attributes = ["created_at", "delivery_status", "id", "updated_at", "user_id"]
        expect(Order.ransackable_attributes).to match_array(expected_attributes)
      end
    end

    describe '.ransackable_associations' do
      it 'returns the allowed searchable associations' do
        expected_associations = ["company", "delivery_information", "product_snapshots", "user", "order_histories"]
        expect(Order.ransackable_associations).to match_array(expected_associations)
      end
    end
  end

  describe 'acts_as_tenant' do
    it 'is scoped to company' do
      company1 = create(:company)
      company2 = create(:company)

      order1 = create(:order, company: company1)
      order2 = create(:order, company: company2)

      ActsAsTenant.with_tenant(company1) do
        expect(Order.all).to include(order1)
        expect(Order.all).not_to include(order2)
      end
    end
  end

  describe 'factory traits' do
    it 'creates orders with different statuses' do
      confirmed = create(:confirmed_order, company: create(:company))
      shipped = create(:shipped_order, company: create(:company))
      delivered = create(:delivered_order, company: create(:company))
      cancelled = create(:cancelled_order, company: create(:company))

      expect(confirmed).to be_confirmed
      expect(shipped).to be_shipped
      expect(delivered).to be_delivered
      expect(cancelled).to be_cancelled
    end

    it 'creates complete order with associations' do
      complete = create(:complete_order, company: create(:company))

      expect(complete.delivery_information).to be_present
      expect(complete.product_snapshots.count).to eq(3)
    end
  end

  describe 'order lifecycle' do
    it 'can transition through all statuses' do
      order = create(:order) # starts as pending

      expect(order).to be_pending

      order.update!(delivery_status: :confirmed)
      expect(order).to be_confirmed

      order.update!(delivery_status: :shipped)
      expect(order).to be_shipped

      order.update!(delivery_status: :delivered)
      expect(order).to be_delivered

      # Check that all transitions were recorded
      expect(order.order_histories.count).to eq(4) # initial + 3 transitions
    end

    it 'can be cancelled from any status' do
      order = create(:confirmed_order)

      order.update!(delivery_status: :cancelled)
      expect(order).to be_cancelled

      history = order.order_histories.last
      expect(history.status_from).to eq('confirmed')
      expect(history.status_to).to eq('cancelled')
    end
  end
end
