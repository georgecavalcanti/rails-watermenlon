class CreateNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :notes do |t|
      t.references :schedule, foreign_key: true
      t.references :person, foreign_key: true
      t.string :name
      t.text :content
      t.bigint :external_created_at
      t.bigint :external_update_at
      t.bigint :last_modified_at
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
