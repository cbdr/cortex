class CreateFieldItems < ActiveRecord::Migration
  def change
    create_table :field_items do |t|
      t.text :text
      t.references :field
      t.references :content_item

      t.timestamps null: false
    end
  end
end
