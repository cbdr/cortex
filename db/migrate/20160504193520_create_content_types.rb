class CreateContentTypes < ActiveRecord::Migration
  def change
    create_table :content_types do |t|
      t.string :name, null: false
      t.text :description
      t.integer :creator_id, null: false, index: true

      t.timestamps null: false
    end

  end
end
