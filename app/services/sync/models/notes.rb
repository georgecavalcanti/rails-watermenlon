class Sync::Models::Notes
  def self.columns
    {
      'id' => 'id',
      'schedule_id' => 'schedule_id',
      'person_id' => 'person_id',
      'name' => 'name',
      'content' => 'content',
      'created_at' => 'external_created_at',
      'updated_at' => 'external_updated_at'
    }
  end

  def self.model
    'Note'
  end

  def self.callbacks_model
    [:save]
  end

  def self.params_permit
    {
      notes: [
        created: %i[
          id schedule_id person_id name content created_at updated_at
        ],
        updated: %i[
          id schedule_id person_id name content created_at updated_at
        ],
        deleted: []
      ]
    }
  end

  def self.pull_settings(current_user_id)
    {
      model: 'Note',
      table: 'notes',
      where: begin
        # dates = ((50.days.ago.to_date)..Time.now.to_date).map { |date| date.strftime("%Y-%m-%d") }
        # dates_formatted = dates.flatten.join("','")
        # dates_formatted.gsub!("''", "''''")
        # Some conditions for example

        ""
      end,
      pluck_columns: [
        'id', 'schedule_id', 'person_id', 'name', 'content', 'created_at', 'deleted_at', 'updated_at'
      ],
      columns: "id, schedule_id, person_id, name, content,
                (EXTRACT(EPOCH FROM created_at) * 1000)::bigint,
                (EXTRACT(EPOCH FROM deleted_at) * 1000)::bigint,
                (EXTRACT(EPOCH FROM updated_at) * 1000)::bigint"
    }
  end
end
