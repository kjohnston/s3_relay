## Unreleased

* Update for rails 5.1, update test `dummy` app to rails 5.1
* Adds `optional: true` to the `belongs_to :parent` relation
* Switch from `URI.encode` to `Addressable::URI.escape`
* Add all assigned data to returned json on `create` for ease of testing and flexibility
* Fix issue with upload factory that produced same UUID for every test

## 0.5.1 (January 14, 2017)

* Use simple incrementation strategy for unique-ifying upload requests

## 0.5.0 (December 29, 2016)

* Resolve deprecation warnings for `before_filter` and `skip_before_filter`
* Drop support for Rails 3

## 0.4.2 (December 29, 2016)

* Add unique parameter to new upload request to prevent Safari from consolidating requests

## 0.4.1 (September 7, 2016)

* Set file upload links to open in a new window

## 0.4.0 (September 7, 2016)

* Consolidate virutal attributes defined on parent model for upload UUIDs

## 0.3.2 (April 13, 2016)

* Fix Rails 5.1 deprecation warning

## 0.3.1 (March 17, 2016)

* Fix issues with gem files not being world readable

## 0.3.0 (March 17, 2016)

* Update javscript to perform asynchronously.

* Add uuid, filename, and privateUrl to the upload:success event

* Scope the upload:success event to an element

* Update deprecated position and totalSize attributes with loaded and total respectively

## 0.2.0 (March 17, 2016)

* Add upload:success event when an upload is successfully updated
