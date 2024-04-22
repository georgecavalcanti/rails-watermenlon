class CreateSyncJsons < ActiveRecord::Migration[7.1]
  def change
    create_table :sync_jsons do |t|
      t.bigint :last_pulled_at
      t.json :changes, default: {}

      t.timestamps
    end
  end
end
