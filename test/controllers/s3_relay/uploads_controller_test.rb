require "test_helper"

module S3Relay
  describe UploadsController do
    before do
      S3Relay::Base.any_instance.stubs(:access_key_id)
        .returns("access-key-id")
      S3Relay::Base.any_instance.stubs(:secret_access_key)
        .returns("secret-access-key")
      S3Relay::Base.any_instance.stubs(:region)
        .returns("region")
      S3Relay::Base.any_instance.stubs(:bucket)
        .returns("bucket")
      S3Relay::Base.any_instance.stubs(:acl)
        .returns("acl")
    end

    describe "GET new" do
      it do
        uuid = "123-456-789"
        time = Time.parse("2014-12-01 12:00am")
        S3Relay::UploadPresigner.any_instance.stubs(:uuid).returns(uuid)
        S3Relay::UploadPresigner.any_instance.stubs(:expires).returns(time)

        get new_s3_relay_upload_url
        assert_response 200

        data = JSON.parse(response.body)

        _(data["awsaccesskeyid"]).must_equal "access-key-id"
        _(data["x_amz_server_side_encryption"]).must_equal "AES256"
        _(data["key"]).must_equal "#{uuid}/${filename}"
        _(data["success_action_status"]).must_equal "201"
        _(data["acl"]).must_equal "acl"
        _(data["endpoint"]).must_equal "https://s3.region.amazonaws.com/bucket"
        _(data["policy"].length).must_equal 380  # TODO: Improve this
        _(data["signature"].length).must_equal 28  # TODO: Improve this
        _(data["uuid"]).must_equal uuid
      end
    end

    describe "POST create" do

      describe "success" do
        it do
          assert_difference "S3Relay::Upload.count", 1 do
            post s3_relay_uploads_url, params: {
              association:  "photo_uploads",
              uuid:         SecureRandom.uuid,
              filename:     "cat.png",
              content_type: "image/png"
            }
          end

          assert_response 201
        end

        describe "with parent attributes" do
          describe "matching an object" do
            before { @product = FactoryBot.create(:product) }

            it do
              assert_difference "@product.photo_uploads.count", 1 do
                post s3_relay_uploads_url, params: {
                  association:  "photo_uploads",
                  uuid:         SecureRandom.uuid,
                  filename:     "cat.png",
                  content_type: "image/png",
                  parent_type:  @product.class.to_s,
                  parent_id:    @product.id.to_s
                }
              end

              assert_response 201
            end
          end

          describe "not matching an object" do
            it do
              assert_difference "S3Relay::Upload.count" do
                post s3_relay_uploads_url, params: {
                  association:  "photo_uploads",
                  uuid:         SecureRandom.uuid,
                  filename:     "cat.png",
                  content_type: "image/png",
                  parent_type:  "Product",
                  parent_id:    "10000000"
                }
              end

              assert_response 201
              body = JSON.parse(response.body)

              assert body["parent_type"] == nil
              assert body["parent_id"] == nil
            end
          end

          describe "with a current_user" do
            before do
              @user = OpenStruct.new(id: 123)
              UploadsController.any_instance.stubs(:current_user).returns(@user)
            end

            it "associates the upload with the user" do
              assert_difference "S3Relay::Upload.count", 1 do
                post s3_relay_uploads_url, params: {
                  association:  "photo_uploads",
                  uuid:         SecureRandom.uuid,
                  filename:     "cat.png",
                  content_type: "image/png"
                }
              end

              assert_response 201
              body = JSON.parse(response.body)
              _(body["user_id"]).must_equal @user.id
            end
          end

        end
      end

      describe "error" do
        it do
          assert_no_difference "S3Relay::Upload.count" do
            post s3_relay_uploads_url, params: {
              uuid:         SecureRandom.uuid,
              filename:     "cat.png",
              content_type: "image/png"
            }
          end

          assert_response 422

          _(JSON.parse(response.body)["errors"]["upload_type"])
            .must_include "can't be blank"
        end
      end

    end

  end
end
