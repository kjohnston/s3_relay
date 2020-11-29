require "test_helper"

describe S3Relay::Upload do
  before do
    @upload = FactoryBot.build(:upload)
  end

  describe "associations" do
    describe "parent" do
      it do
        _(S3Relay::Upload.reflect_on_association(:parent).macro)
          .must_equal :belongs_to
      end
    end
  end

  describe "validations" do
    describe "uuid" do
      it "validates presence" do
        @upload.uuid = nil
        @upload.valid?
        _(@upload.errors[:uuid]).must_include("can't be blank")
      end

      it "validates uniqueness" do
        FactoryBot.create(:file_upload, uuid: @upload.uuid)
        @upload.valid?
        _(@upload.errors[:uuid]).must_include("has already been taken")
      end
    end

    describe "upload_type" do
      it "validates presence" do
        @upload.valid?
        _(@upload.errors[:upload_type]).must_include("can't be blank")
      end
    end

    describe "filename" do
      it "validates presence" do
        @upload.valid?
        _(@upload.errors[:filename]).must_include("can't be blank")
      end
    end

    describe "content_type" do
      it "validates presence" do
        @upload.valid?
        _(@upload.errors[:content_type]).must_include("can't be blank")
      end
    end

    describe "pending_at" do
      it "validates presence" do
        @upload.pending_at = nil
        @upload.valid?
        _(@upload.errors[:pending_at]).must_include("can't be blank")
      end
    end
  end

  describe "scopes" do
    before do
      @pending = FactoryBot.build(:file_upload)
        .tap { |u| u.save(validate: false) }
      @imported = FactoryBot.build(:upload, state: "imported")
        .tap { |u| u.save(validate: false) }
    end

    describe "pending" do
      it do
        results = S3Relay::Upload.pending.all
        _(results).must_include @pending
        _(results).wont_include @imported
      end
    end

    describe "imported" do
      it do
        results = S3Relay::Upload.imported.all
        _(results).wont_include @pending
        _(results).must_include @imported
      end
    end
  end

  describe "upon finalization" do
    it do
      _(@upload.state).must_equal "pending"
      _(@upload.pending_at).wont_equal nil
    end
  end

  describe "#pending?" do
    it { _(@upload.pending?).must_equal true }
  end

  describe "#imported" do
    it do
      @upload.state = "imported"
      _(@upload.imported?).must_equal true
    end
  end

  describe "#mark_imported!" do
    it do
      @upload.mark_imported!
      _(@upload.state).must_equal "imported"
      _(@upload.imported_at).wont_equal nil
    end
  end

  describe "#notify_parent" do
    before { @upload = FactoryBot.build(:file_upload) }

    describe "when the parent is associated" do
      it do
        @product = FactoryBot.create(:product)
        @upload.parent = @product
        @product.expects(:import_upload)
        @upload.save
      end
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

      _(@upload.private_url).must_equal url
    end
  end

end
