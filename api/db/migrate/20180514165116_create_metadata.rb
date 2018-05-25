class CreateMetadata < ActiveRecord::Migration[5.2]
  def change
    create_table :metadata do |t|
      t.text :metadata
      t.datetime :parsed_at
      t.references :domain, foreign_key: true

      t.timestamps
    end
  end
end
