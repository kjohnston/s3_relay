require "test_helper"

describe S3Relay::Upload do
  before do
    @upload = S3Relay::Upload.new
  end

  describe "associations" do
    describe "parent" do
      it do
        S3Relay::Upload.reflect_on_association(:parent).macro
          .must_equal :belongs_to
      end
    end
  end

  describe "validations" do
    describe "uuid" do
      it "validates presence" do
        @upload.valid?
        @upload.errors[:uuid].must_include("can't be blank")
      end

      it "validates uniqueness" do
        S3Relay::Upload.new(uuid: @upload.uuid).save!(validate: false)
        @upload.valid?
        @upload.errors[:uuid].must_include("has already been taken")
      end
    end

    describe "filename" do
      it "validates presence" do
        @upload.valid?
        @upload.errors[:filename].must_include("can't be blank")
      end
    end

    describe "content_type" do
      it "validates presence" do
        @upload.valid?
        @upload.errors[:content_type].must_include("can't be blank")
      end
    end

    describe "pending_at" do
      it "validates presence" do
        @upload.pending_at = nil
        @upload.valid?
        @upload.errors[:pending_at].must_include("can't be blank")
      end
    end
  end

  describe "scopes" do
    before do
      @pending = S3Relay::Upload.new
        .tap { |u| u.save(validate: false) }
      @imported = S3Relay::Upload.new(state: "imported")
        .tap { |u| u.save(validate: false) }
    end

    describe "pending" do
      it do
        results = S3Relay::Upload.pending.all
        results.must_include @pending
        results.wont_include @imported
      end
    end

    describe "imported" do
      it do
        results = S3Relay::Upload.imported.all
        results.wont_include @pending
        results.must_include @imported
      end
    end
  end

  describe "upon finalization" do
    it do
      @upload.state.must_equal "pending"
      @upload.pending_at.wont_equal nil
    end
  end

  describe "#pending?" do
    it { @upload.pending?.must_equal true }
  end

  describe "#imported" do
    it do
      @upload.state = "imported"
      @upload.imported?.must_equal true
    end
  end

  describe "#mark_imported!" do
    it do
      @upload.mark_imported!
      @upload.state.must_equal "imported"
      @upload.imported_at.wont_equal nil
    end
  end

  describe "#private_url" do
    it do
      uuid             = SecureRandom.uuid
      filename         = "cat.png"
      @upload.uuid     = uuid
      @upload.filename = filename

      url   = "url"
      klass = stub
      S3Relay::PrivateUrl.expects(:new).with(uuid, filename).returns(klass)
      klass.expects(:generate).returns(url)

      @upload.private_url.must_equal url
    end
  end

end
