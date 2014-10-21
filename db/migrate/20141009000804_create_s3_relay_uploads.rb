class CreateS3RelayUploads < ActiveRecord::Migration
  def change
    create_table :s3_relay_uploads do |t|
      t.binary :uuid, length: 16
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
