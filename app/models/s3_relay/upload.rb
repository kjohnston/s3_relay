module S3Relay
  class Upload < ActiveRecord::Base

    validates :uuid,        presence: true, uniqueness: true
    validates :filename,    presence: true
    validates :public_url,  presence: true
    validates :uploaded_at, presence: true

    after_initialize :finalize, on: :create

    def self.uploaded
      where(state: "uploaded")
    end

    def self.processed
      where(state: "processed")
    end

    def mark_processed!
      update_attributes(state: "processed", processed_at: Time.now)
    end

    def private_url
      S3Relay::PrivateUrl.new(public_url).generate
    end

    private

    def finalize
      self.state       = "uploaded"
      self.uploaded_at = Time.now
    end

  end
end
