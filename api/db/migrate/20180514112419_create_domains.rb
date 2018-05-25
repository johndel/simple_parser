class CreateDomains < ActiveRecord::Migration[5.2]
  def change
    create_table :domains do |t|
      t.string :domain
      t.text :url
      t.datetime :parsed_at
      t.string :facebook
      t.string :twitter
      t.string :youtube
      t.string :instagram

      t.timestamps
    end
  end
end
