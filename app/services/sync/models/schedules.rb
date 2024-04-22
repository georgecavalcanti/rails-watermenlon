class Sync::Models::Schedules
  def self.columns
    {
      'id' => 'id',
      'person_id' => 'person_id',
      'name' => 'name',
      'execution_date' => 'execution_date',
      'created_at' => 'external_created_at',
      'updated_at' => 'external_updated_at'
    }
  end

  def self.model
    'Schedule'
  end

  def self.callbacks_model
    [:save]
  end

  def self.params_permit
    {
      schedules: [
        created: %i[
          id person_id name execution_date created_at updated_at
        ],
        updated: %i[
          id person_id name execution_date created_at updated_at
        ],
        deleted: []
      ]
    }
  end

  def self.pull_settings
    {
      model: 'Schedule',
      table: 'schedules',
      where: begin
        # dates = ((50.days.ago.to_date)..Time.now.to_date).map { |date| date.strftime("%Y-%m-%d") }
        # dates_formatted = dates.flatten.join("','")
        # dates_formatted.gsub!("''", "''''")
        # Some conditions for example

        ""
      end,
      pluck_columns: [
        'id', 'person_id', 'name', 'execution_date', 'created_at', 'deleted_at', 'updated_at'
      ],
      columns: "id, person_id, name, execution_date,
                (EXTRACT(EPOCH FROM created_at) * 1000)::bigint,
                (EXTRACT(EPOCH FROM deleted_at) * 1000)::bigint,
                (EXTRACT(EPOCH FROM updated_at) * 1000)::bigint"
    }
  end
end
