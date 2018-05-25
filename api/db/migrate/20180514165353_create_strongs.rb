class CreateStrongs < ActiveRecord::Migration[5.2]
  def change
    create_table :strongs do |t|
      t.text :phrase
      t.datetime :parsed_at
      t.references :domain, foreign_key: true

      t.timestamps
    end
  end
end
