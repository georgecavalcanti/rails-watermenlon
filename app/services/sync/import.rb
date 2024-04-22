class Sync::Import
  prepend SimpleCommand

  def initialize(
    values, columns, model, callbacks_model = []
  )
    @values_for_create = values[:created]
    @values_for_update = values[:updated]
    @values_for_delete = values[:deleted]
    @model = model
    @columns = columns
    @callbacks_model = callbacks_model
  end

  def call
    import_create
    import_update
    import_delete

    {}
  end

  private

  def import_create
    import_values(@values_for_create)
  rescue => e
    errors.add(:error_import_create, e.to_s)
  end

  def import_update
    import_values(@values_for_update)
  rescue => e
    errors.add(:error_import_update, e.to_s)
  end

  def import_delete
    ImportDeleteJob.set(wait: 5.seconds).perform_later(@model, @values_for_delete)
    # @model.constantize.where(id: @values_for_delete).destroy_all
  rescue => e
    errors.add(:error_import_delete, e.to_s)
  end

  def import_values(values)
    values_format = []

    values_format = values.map do |obj|
      object = @model.constantize.new(
        obj.transform_keys(&@columns.method(:[]))
      )

      @callbacks_model.each { |cb| object.run_callbacks(cb) { true } }

      object
    end

    @model.constantize.import(
      values_format,
      on_duplicate_key_update: {
        conflict_target: [:id],
        index_predicate: 'deleted_at IS NULL',
        columns: @columns.values.map{|a| a.to_sym}
      },
      batch_size: 10
    )

    values_format = []

    values_format
  end
end
