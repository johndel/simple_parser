class CreateHeaders < ActiveRecord::Migration[5.2]
  def change
    create_table :headers do |t|
      t.text :phrase
      t.string :header_type
      t.datetime :parsed_at
      t.references :domain, foreign_key: true

      t.timestamps
    end
  end
end
