# s3_relay

## Overview

Direct uploads to S3 and ingestion by your Rails app.

### Tenets

* Users are best served by uploading files from their browser to S3.
* Your Rails app will asynchronously ingest files uploaded directly to S3.
* You may use any file upload/processing libraries you like or none at all to manage ingested files.
* This gem does not depend on any of the other AWS libraries - they are hefty, advance quickly, are overkill for this solution and you may have one or more of them in your app already.

## Contributing

1. [Fork it](https://github.com/kjohnston/s3_relay/fork_select)
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
