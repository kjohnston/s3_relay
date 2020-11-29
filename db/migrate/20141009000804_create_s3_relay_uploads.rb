class CreateS3RelayUploads < ActiveRecord::Migration[5.0]
  def change
    create_table :s3_relay_uploads do |t|
      t.binary :uuid, length: 16
      t.integer :user_id
      t.string :parent_type
      t.integer :parent_id
      t.string :upload_type
      t.text :filename
      t.string :content_type
      t.string :state
      t.column :data, :json, default: "{}"
      t.datetime :pending_at
      t.datetime :imported_at

      t.timestamps
    end
  end
end
