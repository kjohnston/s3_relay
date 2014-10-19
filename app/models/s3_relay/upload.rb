module S3Relay
  class Upload < ActiveRecord::Base

    belongs_to :parent, polymorphic: true

    validates :uuid,         presence: true, uniqueness: true
    validates :filename,     presence: true
    validates :content_type, presence: true
    validates :pending_at,   presence: true

    after_initialize :finalize

    def self.pending
      where(state: "pending")
    end

    def self.imported
      where(state: "imported")
    end

    def pending?
      state == "pending"
    end

    def imported?
      state == "imported"
    end

    def mark_imported!
      update_attributes(state: "imported", imported_at: Time.now)
    end

    def private_url
      S3Relay::PrivateUrl.new(uuid, filename).generate
    end

    private

    def finalize
      self.state      ||= "pending"
      self.pending_at ||= Time.now
    end

  end
end
