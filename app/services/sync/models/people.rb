class Sync::Models::People
  def self.columns
    {
      'id' => 'id',
      'name' => 'name',
      'created_at' => 'external_created_at',
      'updated_at' => 'external_updated_at'
    }
  end

  def self.model
    'Person'
  end

  def self.callbacks_model
    [:save]
  end

  def self.params_permit
    {
      people: [
        created: %i[
          id name created_at updated_at
        ],
        updated: %i[
          id name created_at updated_at
        ],
        deleted: []
      ]
    }
  end

  def self.pull_settings
    {
      model: 'Person',
      table: 'people',
      where: begin
        # dates = ((50.days.ago.to_date)..Time.now.to_date).map { |date| date.strftime("%Y-%m-%d") }
        # dates_formatted = dates.flatten.join("','")
        # dates_formatted.gsub!("''", "''''")
        # Some conditions for example

        ""
      end,
      pluck_columns: [
        'id', 'name', 'created_at', 'deleted_at', 'updated_at'
      ],
      columns: "id, name,
                (EXTRACT(EPOCH FROM created_at) * 1000)::bigint,
                (EXTRACT(EPOCH FROM deleted_at) * 1000)::bigint,
                (EXTRACT(EPOCH FROM updated_at) * 1000)::bigint"
    }
  end
end
