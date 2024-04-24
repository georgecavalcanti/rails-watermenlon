class Sync::PushChanges
  prepend SimpleCommand

  def initialize(changes, last_pulled_at)
    @last_pulled_at = last_pulled_at.to_i
    @changes = changes
    @keys = changes&.keys
  end

  def call
    sync_push
  end

  private

  def sync_push
    return errors.add(:key_errors, 'Changes is empty!') if @changes == {}

    ActiveRecord::Base.transaction do
      @keys.each do |key|
        import_create(key)
      end

      raise ActiveRecord::Rollback unless errors.full_messages.empty?
    end

    ::Sync::PushJson.call(
      @changes, @last_pulled_at
    )
  
    nil
  end

  def import_create(key)
    configs_key = get_configs(key)
    return unless configs_key && configs_key[:columns] && configs_key[:model]

    service = Sync::Import.call(
      @changes[key], configs_key[:columns], configs_key[:model], configs_key[:callbacks_model]
    )

    errors.add("service_import_#{key.to_s}".to_sym, service.errors.full_messages) unless service.success?
  end

  def get_configs(key)
    {
      columns: "Sync::Models::#{key.to_s.camelize}".constantize.try(:columns),
      model: "Sync::Models::#{key.to_s.camelize}".constantize.try(:model),
      callbacks_model: "Sync::Models::#{key.to_s.camelize}".constantize.try(:callbacks_model)
    }
  rescue NameError
    p "Error get configs"

    ActiveRecord::Base.connection.execute 'ROLLBACK'

    errors.add(
      "service_import_#{key.to_s}".to_sym,
      "#{key.camalize} Config Doesn't exists."
    )
  end
end
