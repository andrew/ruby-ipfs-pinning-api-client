# openapi_client

OpenapiClient - the Ruby gem for the IPFS Pinning Service API



## About this spec
The IPFS Pinning Service API is intended to be an implementation-agnostic API&#x3a;
- For use and implementation by pinning service providers
- For use in client mode by IPFS nodes and GUI-based applications

> **Note**: while ready for implementation, this spec is still a work in progress! 🏗️  **Your input and feedback are welcome and valuable as we develop this API spec. Please join the design discussion at [github.com/ipfs/pinning-services-api-spec](https://github.com/ipfs/pinning-services-api-spec).**

# Schemas
This section describes the most important object types and conventions.

A full list of fields and schemas can be found in the `schemas` section of the [YAML file](https://github.com/ipfs/pinning-services-api-spec/blob/master/ipfs-pinning-service.yaml).

## Identifiers
### cid
[Content Identifier (CID)](https://docs.ipfs.io/concepts/content-addressing/) points at the root of a DAG that is pinned recursively.
### requestid
Unique identifier of a pin request.

When a pin is created, the service responds with unique `requestid` that can be later used for pin removal. When the same `cid` is pinned again, a different `requestid` is returned to differentiate between those pin requests.

Service implementation should use UUID, `hash(accessToken,Pin,PinStatus.created)`, or any other opaque identifier that provides equally strong protection against race conditions.

## Objects
### Pin object

![pin object](https://bafybeideck2fchyxna4wqwc2mo67yriokehw3yujboc5redjdaajrk2fjq.ipfs.dweb.link/pin.png)

The `Pin` object is a representation of a pin request.

It includes the `cid` of data to be pinned, as well as optional metadata in `name`, `origins`, and `meta`.

### Pin status response

![pin status response object](https://bafybeideck2fchyxna4wqwc2mo67yriokehw3yujboc5redjdaajrk2fjq.ipfs.dweb.link/pinstatus.png)

The `PinStatus` object is a representation of the current state of a pinning operation.
It includes the original `pin` object, along with the current `status` and globally unique `requestid` of the entire pinning request, which can be used for future status checks and management. Addresses in the `delegates` array are peers delegated by the pinning service for facilitating direct file transfers (more details in the provider hints section). Any additional vendor-specific information is returned in optional `info`.

## The pin lifecycle

![pinning service objects and lifecycle](https://bafybeideck2fchyxna4wqwc2mo67yriokehw3yujboc5redjdaajrk2fjq.ipfs.dweb.link/lifecycle.png)

### Creating a new pin object
The user sends a `Pin` object to `POST /pins` and receives a `PinStatus` response:
- `requestid` in `PinStatus` is the identifier of the pin operation, which can can be used for checking status, and removing the pin in the future
- `status` in `PinStatus` indicates the current state of a pin

### Checking status of in-progress pinning
`status` (in `PinStatus`) may indicate a pending state (`queued` or `pinning`). This means the data behind `Pin.cid` was not found on the pinning service and is being fetched from the IPFS network at large, which may take time.

In this case, the user can periodically check pinning progress via `GET /pins/{requestid}` until pinning is successful, or the user decides to remove the pending pin.

### Replacing an existing pin object
The user can replace an existing pin object via `POST /pins/{requestid}`. This is a shortcut for removing a pin object identified by `requestid` and creating a new one in a single API call that protects against undesired garbage collection of blocks common to both pins. Useful when updating a pin representing a huge dataset where most of blocks did not change. The new pin object `requestid` is returned in the `PinStatus` response. The old pin object is deleted automatically.

### Removing a pin object
A pin object can be removed via `DELETE /pins/{requestid}`.


## Provider hints
Pinning of new data can be accelerated by providing a list of known data sources in `Pin.origins`, and connecting at least one of them to pinning service nodes at `PinStatus.delegates`.

The most common scenario is a client putting its own IPFS node's multiaddrs in `Pin.origins`,  and then directly connecting to every multiaddr returned by a pinning service in `PinStatus.delegates` to initiate transfer.

This ensures data transfer starts immediately (without waiting for provider discovery over DHT), and direct dial from a client works around peer routing issues in restrictive network topologies such as NATs.

## Custom metadata
Pinning services are encouraged to add support for additional features by leveraging the optional `Pin.meta` and `PinStatus.info` fields. While these attributes can be application- or vendor-specific, we encourage the community at large to leverage these attributes as a sandbox to come up with conventions that could become part of future revisions of this API.
### Pin metadata
String keys and values passed in `Pin.meta` are persisted with the pin object.

Potential uses:
- `Pin.meta[app_id]`: Attaching a unique identifier to pins created by an app enables filtering pins per app via `?meta={\"app_id\":<UUID>}`
- `Pin.meta[vendor_policy]`: Vendor-specific policy (for example: which region to use, how many copies to keep)

Note that it is OK for a client to omit or ignore these optional attributes; doing so should not impact the basic pinning functionality.

### Pin status info
Additional `PinStatus.info` can be returned by pinning service.

Potential uses:
- `PinStatus.info[status_details]`: more info about the current status (queue position, percentage of transferred data, summary of where data is stored, etc); when `PinStatus.status=failed`, it could provide a reason why a pin operation failed (e.g. lack of funds, DAG too big, etc.)
- `PinStatus.info[dag_size]`: the size of pinned data, along with DAG overhead
- `PinStatus.info[raw_size]`: the size of data without DAG overhead (eg. unixfs)
- `PinStatus.info[pinned_until]`: if vendor supports time-bound pins, this could indicate when the pin will expire

# Pagination and filtering
Pin objects can be listed by executing `GET /pins` with optional parameters:

- When no filters are provided, the endpoint will return a small batch of the 10 most recently created items, from the latest to the oldest.
- The number of returned items can be adjusted with the `limit` parameter (implicit default is 10).
- If the value in `PinResults.count` is bigger than the length of `PinResults.results`, the client can infer there are more results that can be queried.
- To read more items, pass the `before` filter with the timestamp from `PinStatus.created` found in the oldest item in the current batch of results. Repeat to read all results.
- Returned results can be fine-tuned by applying optional `after`, `cid`, `name`, `status`, or `meta` filters.

> **Note**: pagination by the `created` timestamp requires each value to be globally unique. Any future considerations to add support for bulk creation must account for this.



This SDK is automatically generated by the [OpenAPI Generator](https://openapi-generator.tech) project:

- API version: 0.0.5
- Package version: 1.0.0
- Build package: org.openapitools.codegen.languages.RubyClientCodegen

## Installation

### Build a gem

To build the Ruby code into a gem:

```shell
gem build openapi_client.gemspec
```

Then either install the gem locally:

```shell
gem install ./openapi_client-1.0.0.gem
```

(for development, run `gem install --dev ./openapi_client-1.0.0.gem` to install the development dependencies)

or publish the gem to a gem hosting service, e.g. [RubyGems](https://rubygems.org/).

Finally add this to the Gemfile:

    gem 'openapi_client', '~> 1.0.0'

### Install from Git

If the Ruby gem is hosted at a git repository: https://github.com/andrew/ruby-ipfs-pinning-api-client, then add the following in the Gemfile:

    gem 'openapi_client', :git => 'https://github.com/andrew/ruby-ipfs-pinning-api-client.git'

### Include the Ruby code directly

Include the Ruby code directly using `-I` as follows:

```shell
ruby -Ilib script.rb
```

## Getting Started

Please follow the [installation](#installation) procedure and then run the following code:

```ruby
# Load the gem
require 'openapi_client'

# Setup authorization
OpenapiClient.configure do |config|
  # Configure Bearer authorization: accessToken
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = OpenapiClient::PinsApi.new
opts = {
  cid: ['[\"Qm1\",\"Qm2\",\"bafy3\"]'], # Array<String> | Return pin objects responsible for pinning the specified CID(s); be aware that using longer hash functions introduces further constraints on the number of CIDs that will fit under the limit of 2000 characters per URL  in browser contexts
  name: 'my precious', # String | Return pin objects with names that contain provided value (case-insensitive, partial or full match)
  status: [OpenapiClient::Status.new], # Array<Status> | Return pin objects for pins with the specified status
  before: DateTime.parse('2020-07-27T17:32:28Z'), # DateTime | Return results created (queued) before provided timestamp
  after: DateTime.parse('2020-07-27T17:32:28Z'), # DateTime | Return results created (queued) after provided timestamp
  limit: 10, # Integer | Max records to return
  meta: {'key' => 'meta_example'} # Hash<String, String> | Return pin objects that match specified metadata
}

begin
  #List pin objects
  result = api_instance.pins_get(opts)
  p result
rescue OpenapiClient::ApiError => e
  puts "Exception when calling PinsApi->pins_get: #{e}"
end

```

## Documentation for API Endpoints

All URIs are relative to *https://pinning-service.example.com*

Class | Method | HTTP request | Description
------------ | ------------- | ------------- | -------------
*OpenapiClient::PinsApi* | [**pins_get**](docs/PinsApi.md#pins_get) | **GET** /pins | List pin objects
*OpenapiClient::PinsApi* | [**pins_post**](docs/PinsApi.md#pins_post) | **POST** /pins | Add pin object
*OpenapiClient::PinsApi* | [**pins_requestid_delete**](docs/PinsApi.md#pins_requestid_delete) | **DELETE** /pins/{requestid} | Remove pin object
*OpenapiClient::PinsApi* | [**pins_requestid_get**](docs/PinsApi.md#pins_requestid_get) | **GET** /pins/{requestid} | Get pin object
*OpenapiClient::PinsApi* | [**pins_requestid_post**](docs/PinsApi.md#pins_requestid_post) | **POST** /pins/{requestid} | Replace pin object


## Documentation for Models

 - [OpenapiClient::Error](docs/Error.md)
 - [OpenapiClient::ErrorError](docs/ErrorError.md)
 - [OpenapiClient::Pin](docs/Pin.md)
 - [OpenapiClient::PinResults](docs/PinResults.md)
 - [OpenapiClient::PinStatus](docs/PinStatus.md)
 - [OpenapiClient::Status](docs/Status.md)


## Documentation for Authorization


### accessToken

- **Type**: Bearer authentication

