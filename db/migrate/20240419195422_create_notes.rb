class CreateNotes < ActiveRecord::Migration[7.1]
  def change
    create_table :notes, id: :uuid do |t|
      t.references :schedule, index: true, foreign_key: true, type: :uuid
      t.references :person, index: true, foreign_key: true, type: :uuid
      t.string :name
      t.text :content
      t.bigint :external_created_at
      t.bigint :external_updated_at
      t.bigint :last_modified_at
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
