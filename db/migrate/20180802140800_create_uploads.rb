class CreateUploads < ActiveRecord::Migration[5.1]
  def change
    create_table :uploads do |t|
      t.string :image

      t.timestamps
      t.string :user_id
    end
  end
end
