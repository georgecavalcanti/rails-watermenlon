class CreateAssets < ActiveRecord::Migration[7.1]
  def change
    create_table :assets do |t|
      t.string :name
      t.bigint :external_created_at
      t.bigint :external_update_at
      t.bigint :last_modified_at
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
