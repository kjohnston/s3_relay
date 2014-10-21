# s3_relay

## Overview

Direct uploads to S3 and ingestion by your Rails app.

### Tenets

* Users are best served by uploading files from their browser to S3.
* Your Rails app will asynchronously ingest files uploaded directly to S3.
* You may use any file upload/processing libraries you like or none at all to manage ingested files.
* This gem does not depend on any of the other AWS libraries - they are hefty, advance quickly, are overkill for this solution and you may have one or more of them in your app already.

## Installation

* Add `gem "s3_relay"` to your Gemfile and run `bundle`.
* Add migrations to your app and run them with `rake s3_relay:install:migrations db:migrate`.
* Add `mount S3Relay::Engine => "/s3_relay"` to the top of your routes file.
* Add `require s3_relay` to your JavaScript manifest.
* Add `require s3_relay` to your Style Sheet manifest.
* Add the following environment variables to your app:

```
S3_RELAY_ACCESS_KEY_ID="abc123"
S3_RELAY_SECRET_ACCESS_KEY="xzy456"
S3_RELAY_REGION="us-west-2"
S3_RELAY_BUCKET="some-s3-bucket"
S3_RELAY_ACL="private"
```

## Contributing

1. [Fork it](https://github.com/kjohnston/s3_relay/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. [Create a Pull Request](https://github.com/kjohnston/s3_relay/pull/new)

## Contributors

Many thanks go to the following who have contributed to making this gem even better:

[your name here]

## License

* Freely distributable and licensed under the [MIT license](http://kjohnston.mit-license.org/license.html).
* Copyright (c) 2014 Kenny Johnston
