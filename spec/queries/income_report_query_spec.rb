require 'rails_helper'

RSpec.describe IncomeReportQuery do
  let!(:user) { create(:user) }

  describe '#resolve' do
    let(:test_scope) { instance_double(ActiveRecord::Relation) }
    let(:result) { query.resolve }

    context 'filtering by nothing' do
      let(:query) { described_class.new(relation: Purchase.all, filters: {}) }
      let!(:purchase_1) { create(:purchase, :with_user) }
      let!(:purchase_2) { create(:purchase, :with_user, :income) }
      let!(:purchase_3) { create(:purchase, :with_user, :income) }

      it 'returns the expected purchases' do
        expect(result).to match_array([purchase_2, purchase_3])
      end
    end

    context 'filtering by start date' do
      let(:query) { described_class.new(relation: Purchase.all, filters: filters) }
      let(:filters) { { start_date: '2019-06-01' } }
      let!(:purchase_1) { create(:purchase, :with_user, :income, created_at: '2019-05-31 23:59:59') }
      let!(:purchase_2) { create(:purchase, :with_user, :income, created_at: '2019-06-01 00:00:00') }
      let!(:purchase_3) { create(:purchase, :with_user, :income, created_at: '2019-06-01 23:59:59') }

      it 'returns the expected purchases' do
        expect(result).to match_array([purchase_2, purchase_3])
      end
    end

    context 'filtering by end date' do
      let(:query) { described_class.new(relation: Purchase.all, filters: filters) }
      let(:filters) { { end_date: '2019-05-31' } }
      let!(:purchase_1) { create(:purchase, :with_user, :income, created_at: '2019-05-31 23:59:59') }
      let!(:purchase_2) { create(:purchase, :with_user, :income, created_at: '2019-06-01 00:00:00') }
      let!(:purchase_3) { create(:purchase, :with_user, :income, created_at: '2019-06-01 23:59:59') }

      it 'returns the expected purchases' do
        expect(result).to match_array([purchase_1])
      end
    end

    context 'filtering by start date and end date' do
      let(:query) { described_class.new(relation: Purchase.all, filters: filters) }
      let(:filters) { { start_date: '2019-05-31', end_date: '2019-06-01' } }
      let!(:purchase_1) { create(:purchase, :with_user, :income, created_at: '2019-05-31 23:59:59') }
      let!(:purchase_2) { create(:purchase, :with_user, :income, created_at: '2019-06-01 00:00:00') }
      let!(:purchase_3) { create(:purchase, :with_user, :income, created_at: '2019-06-01 23:59:59') }
      let!(:purchase_4) { create(:purchase, :with_user, :income, created_at: '2019-06-02 00:00:00') }

      it 'returns the expected purchases' do
        expect(result).to match_array([purchase_1, purchase_2, purchase_3])
      end
    end

    context 'filtering by user status' do
      let(:query) { described_class.new(relation: Purchase.all, filters: filters) }
      let(:filters) { { user_status: 'inactive' } }
      let!(:purchase_1) { create(:purchase, :with_user, :income) }
      let!(:purchase_2) { create(:purchase, :with_user, :income) }
      let!(:purchase_3) { create(:purchase, :income, user: create(:user, :inactive)) }

      it 'returns the expected purchases' do
        expect(result).to match_array([purchase_3])
      end
    end

    context 'filtering by user id' do
      let(:query) { described_class.new(relation: Purchase.all, filters: filters) }
      let(:filters) { { user_id: user.id } }
      let!(:purchase_1) { create(:purchase, :income, :with_user) }
      let!(:purchase_2) { create(:purchase, :income, user: user) }
      let!(:purchase_3) { create(:purchase, :income, user: user) }

      it 'returns the expected purchases' do
        expect(result).to match_array([purchase_2, purchase_3])
      end
    end

    context 'filtering by minimum amount' do
      let(:query) { described_class.new(relation: Purchase.all, filters: filters) }
      let(:filters) { { amount: '100.00' } }
      let!(:purchase_1) { create(:purchase, :with_user, :income, amount: '99.99') }
      let!(:purchase_2) { create(:purchase, :with_user, :income, amount: '100.56') }
      let!(:purchase_3) { create(:purchase, :with_user, :income, amount: '101.23') }

      it 'returns the expected purchases' do
        expect(result).to match_array([purchase_2, purchase_3])
      end
    end
  end
end
