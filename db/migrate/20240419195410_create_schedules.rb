class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.references :person, foreign_key: true
      t.string :execution_date
      t.string :name
      t.bigint :external_created_at
      t.bigint :external_update_at
      t.bigint :last_modified_at
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
