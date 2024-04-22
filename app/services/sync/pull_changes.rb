class Sync::PullChanges
  prepend SimpleCommand

  def initialize(last_pulled_at, page, limit, experimentalStrategy, migration)
    @timestamp = Time.now.to_i
    @last_pulled_at = last_pulled_at.to_i * 1000

    @page = page ? page.to_i : 1
    @limit = limit.to_i == 0 || limit.to_i > 1000 ? 1000 : limit.to_i
    @offset = (@page.zero? || @page == 1 ? 0 : ((@page - 1) * @limit)).abs

    @models = Sync::ModelsPull.models
    @experimental_strategy = experimentalStrategy

    unless migration.blank? || (migration && migration.try(:to_s) == 'null')
      @last_pulled_at = 0
      @experimental_strategy = 'replacement'
    end
  end

  def call
    sync_pull
  end

  private

  def sync_pull
    result = {
      changes: {},
      timestamp: @timestamp,
      next: false
    }

    result[:experimentalStrategy] = @experimental_strategy unless @experimental_strategy.blank?

    @models.each do |model|
      result[:changes][model[:table]] ||= { created: [], updated: [], deleted: [] }

      query(
        model[:model],
        model[:columns],
        model[:where] || '',
        model[:pluck_columns])
      .each do |obj|
        result[:changes][model[:table]][:deleted] << obj['id'] if !@last_pulled_at.blank? && obj['deleted_at']
        result[:changes][model[:table]][:updated] << obj if obj['deleted_at'].blank?
      end

      count_objects = result[:changes][model[:table]][:created].try(:count) +
      result[:changes][model[:table]][:updated].try(:count) +
      result[:changes][model[:table]][:deleted].try(:count)

      result[:next] = true if count_objects >= @limit
    end

    Oj.dump(result, mode: :compat)
  end

  def query(base_model, columns, condition_by_model, pluck_columns)
    base_query = base_model.constantize
    base_query = base_query.with_deleted if @last_pulled_at.positive?
    base_query.order(last_modified_at: :asc)
              .where('last_modified_at > ?', @last_pulled_at)
              .where(condition_by_model)
              .limit(@limit).offset(@offset)
              .pluck(Arel.sql(columns))
              .map do |obj|
                hash = {}
                pluck_columns.each_with_index {|col, i| hash[col] = check_value_type(obj[i]) }
                hash
              end
  end

  def check_value_type(value)
    return value.to_f if value.is_a?(BigDecimal)

    value
  rescue => e
    p "Error check value: #{e.to_s}"

    value
  end
end
