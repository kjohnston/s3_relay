class CreateS3RelayUploads < ActiveRecord::Migration
  def change
    create_table :s3_relay_uploads do |t|
      t.string :parent_type
      t.integer :parent_id
      t.binary :uuid, length: 16
      t.text :filename
      t.string :content_type
      t.string :state
      t.column :data, :json, default: "{}"
      t.datetime :uploaded_at
      t.datetime :imported_at

      t.timestamps
    end
  end
end
