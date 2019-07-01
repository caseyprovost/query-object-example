class IncomeTransactionsQuery
  attr_reader :relation
  attr_reader :filters

  def initialize(relation:, filters: {})
    @relation = relation
    @filters = filters
  end

  def resolve
    scope = relation.completed.not_refunded
    return scope.distinct if filters.empty?

    apply_filter(scope, :start_date)
      .yield_self { |scope| apply_filter(scope, :end_date) }
      .yield_self { |scope| apply_filter(scope, :user_status) }
      .yield_self { |scope| apply_filter(scope, :user_id) }
      .yield_self { |scope| apply_filter(scope, :amount) }
      .yield_self { |scope| scope.distinct }
  end

  private

  def apply_filter(scope, filter)
    return scope if filters[filter].nil?
    send("filter_by_#{filter}", scope, filters[filter])
  end

  def filter_by_start_date(scope, value)
    scope.where(created_at: value.to_datetime.beginning_of_day)
  end

  def filter_by_end_date(scope, value)
    scope.where(created_at: value.to_datetime.end_of_day)
  end

  def filter_by_user_status(scope, value)
    scope.joins(:user).where(user: { status: value })
  end

  def filter_by_amount(scope, value)
    scope.where('amount >= ?', value)
  end

  def filter_by_user_id(scope, value)
    scope.joins(:user).where(user: { id: value })
  end
end
