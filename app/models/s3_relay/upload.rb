module S3Relay
  class Upload < ActiveRecord::Base

    belongs_to :parent, polymorphic: true

    validates :uuid,         presence: true, uniqueness: true
    validates :filename,     presence: true
    validates :content_type, presence: true
    validates :uploaded_at,  presence: true

    after_initialize :finalize, on: :create

    def self.pending
      where(state: "pending")
    end

    def self.locked
      where(state: "processed")
    end

    def self.imported
      where(state: "imported")
    end

    def pending?
      state == "pending"
    end

    def locked?
      state == "locked"
    end

    def imported?
      state == "imported"
    end

    def mark_locked!
      update_attributes(state: "locked", locked_at: Time.now)
    end

    def mark_imported!
      update_attributes(state: "imported", imported_at: Time.now)
    end

    def private_url
      S3Relay::PrivateUrl.new(uuid, filename).generate
    end

    private

    def finalize
      self.state       = "pending"
      self.uploaded_at = Time.now
    end

  end
end
