# OpenapiClient::PinsApi

All URIs are relative to *https://pinning-service.example.com*

| Method | HTTP request | Description |
| ------ | ------------ | ----------- |
| [**pins_get**](PinsApi.md#pins_get) | **GET** /pins | List pin objects |
| [**pins_post**](PinsApi.md#pins_post) | **POST** /pins | Add pin object |
| [**pins_requestid_delete**](PinsApi.md#pins_requestid_delete) | **DELETE** /pins/{requestid} | Remove pin object |
| [**pins_requestid_get**](PinsApi.md#pins_requestid_get) | **GET** /pins/{requestid} | Get pin object |
| [**pins_requestid_post**](PinsApi.md#pins_requestid_post) | **POST** /pins/{requestid} | Replace pin object |


## pins_get

> <PinResults> pins_get(opts)

List pin objects

List all the pin objects, matching optional filters; when no filter is provided, only successful pins are returned

### Examples

```ruby
require 'time'
require 'openapi_client'
# setup authorization
OpenapiClient.configure do |config|
  # Configure Bearer authorization: accessToken
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = OpenapiClient::PinsApi.new
opts = {
  cid: ['inner_example'], # Array<String> | Return pin objects responsible for pinning the specified CID(s); be aware that using longer hash functions introduces further constraints on the number of CIDs that will fit under the limit of 2000 characters per URL  in browser contexts
  name: 'PreciousData.pdf', # String | Return pin objects with specified name (by default a case-sensitive, exact match)
  match: OpenapiClient::TextMatchingStrategy::EXACT, # TextMatchingStrategy | Customize the text matching strategy applied when the name filter is present; exact (the default) is a case-sensitive exact match, partial matches anywhere in the name, iexact and ipartial are case-insensitive versions of the exact and partial strategies
  status: [OpenapiClient::Status::QUEUED], # Array<Status> | Return pin objects for pins with the specified status
  before: Time.parse('2020-07-27T17:32:28Z'), # Time | Return results created (queued) before provided timestamp
  after: Time.parse('2020-07-27T17:32:28Z'), # Time | Return results created (queued) after provided timestamp
  limit: 56, # Integer | Max records to return
  meta: { key: 'inner_example'} # Hash<String, String> | Return pin objects that match specified metadata keys passed as a string representation of a JSON object; when implementing a client library, make sure the parameter is URL-encoded to ensure safe transport
}

begin
  # List pin objects
  result = api_instance.pins_get(opts)
  p result
rescue OpenapiClient::ApiError => e
  puts "Error when calling PinsApi->pins_get: #{e}"
end
```

#### Using the pins_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<PinResults>, Integer, Hash)> pins_get_with_http_info(opts)

```ruby
begin
  # List pin objects
  data, status_code, headers = api_instance.pins_get_with_http_info(opts)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <PinResults>
rescue OpenapiClient::ApiError => e
  puts "Error when calling PinsApi->pins_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **cid** | [**Array&lt;String&gt;**](String.md) | Return pin objects responsible for pinning the specified CID(s); be aware that using longer hash functions introduces further constraints on the number of CIDs that will fit under the limit of 2000 characters per URL  in browser contexts | [optional] |
| **name** | **String** | Return pin objects with specified name (by default a case-sensitive, exact match) | [optional] |
| **match** | [**TextMatchingStrategy**](.md) | Customize the text matching strategy applied when the name filter is present; exact (the default) is a case-sensitive exact match, partial matches anywhere in the name, iexact and ipartial are case-insensitive versions of the exact and partial strategies | [optional][default to &#39;exact&#39;] |
| **status** | [**Array&lt;Status&gt;**](Status.md) | Return pin objects for pins with the specified status | [optional] |
| **before** | **Time** | Return results created (queued) before provided timestamp | [optional] |
| **after** | **Time** | Return results created (queued) after provided timestamp | [optional] |
| **limit** | **Integer** | Max records to return | [optional][default to 10] |
| **meta** | [**Hash&lt;String, String&gt;**](String.md) | Return pin objects that match specified metadata keys passed as a string representation of a JSON object; when implementing a client library, make sure the parameter is URL-encoded to ensure safe transport | [optional] |

### Return type

[**PinResults**](PinResults.md)

### Authorization

[accessToken](../README.md#accessToken)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## pins_post

> <PinStatus> pins_post(pin)

Add pin object

Add a new pin object for the current access token

### Examples

```ruby
require 'time'
require 'openapi_client'
# setup authorization
OpenapiClient.configure do |config|
  # Configure Bearer authorization: accessToken
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = OpenapiClient::PinsApi.new
pin = OpenapiClient::Pin.new({cid: 'QmCIDToBePinned'}) # Pin | 

begin
  # Add pin object
  result = api_instance.pins_post(pin)
  p result
rescue OpenapiClient::ApiError => e
  puts "Error when calling PinsApi->pins_post: #{e}"
end
```

#### Using the pins_post_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<PinStatus>, Integer, Hash)> pins_post_with_http_info(pin)

```ruby
begin
  # Add pin object
  data, status_code, headers = api_instance.pins_post_with_http_info(pin)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <PinStatus>
rescue OpenapiClient::ApiError => e
  puts "Error when calling PinsApi->pins_post_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **pin** | [**Pin**](Pin.md) |  |  |

### Return type

[**PinStatus**](PinStatus.md)

### Authorization

[accessToken](../README.md#accessToken)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json


## pins_requestid_delete

> pins_requestid_delete(requestid)

Remove pin object

Remove a pin object

### Examples

```ruby
require 'time'
require 'openapi_client'
# setup authorization
OpenapiClient.configure do |config|
  # Configure Bearer authorization: accessToken
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = OpenapiClient::PinsApi.new
requestid = 'requestid_example' # String | 

begin
  # Remove pin object
  api_instance.pins_requestid_delete(requestid)
rescue OpenapiClient::ApiError => e
  puts "Error when calling PinsApi->pins_requestid_delete: #{e}"
end
```

#### Using the pins_requestid_delete_with_http_info variant

This returns an Array which contains the response data (`nil` in this case), status code and headers.

> <Array(nil, Integer, Hash)> pins_requestid_delete_with_http_info(requestid)

```ruby
begin
  # Remove pin object
  data, status_code, headers = api_instance.pins_requestid_delete_with_http_info(requestid)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => nil
rescue OpenapiClient::ApiError => e
  puts "Error when calling PinsApi->pins_requestid_delete_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **requestid** | **String** |  |  |

### Return type

nil (empty response body)

### Authorization

[accessToken](../README.md#accessToken)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## pins_requestid_get

> <PinStatus> pins_requestid_get(requestid)

Get pin object

Get a pin object and its status

### Examples

```ruby
require 'time'
require 'openapi_client'
# setup authorization
OpenapiClient.configure do |config|
  # Configure Bearer authorization: accessToken
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = OpenapiClient::PinsApi.new
requestid = 'requestid_example' # String | 

begin
  # Get pin object
  result = api_instance.pins_requestid_get(requestid)
  p result
rescue OpenapiClient::ApiError => e
  puts "Error when calling PinsApi->pins_requestid_get: #{e}"
end
```

#### Using the pins_requestid_get_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<PinStatus>, Integer, Hash)> pins_requestid_get_with_http_info(requestid)

```ruby
begin
  # Get pin object
  data, status_code, headers = api_instance.pins_requestid_get_with_http_info(requestid)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <PinStatus>
rescue OpenapiClient::ApiError => e
  puts "Error when calling PinsApi->pins_requestid_get_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **requestid** | **String** |  |  |

### Return type

[**PinStatus**](PinStatus.md)

### Authorization

[accessToken](../README.md#accessToken)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## pins_requestid_post

> <PinStatus> pins_requestid_post(requestid, pin)

Replace pin object

Replace an existing pin object (shortcut for executing remove and add operations in one step to avoid unnecessary garbage collection of blocks present in both recursive pins)

### Examples

```ruby
require 'time'
require 'openapi_client'
# setup authorization
OpenapiClient.configure do |config|
  # Configure Bearer authorization: accessToken
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = OpenapiClient::PinsApi.new
requestid = 'requestid_example' # String | 
pin = OpenapiClient::Pin.new({cid: 'QmCIDToBePinned'}) # Pin | 

begin
  # Replace pin object
  result = api_instance.pins_requestid_post(requestid, pin)
  p result
rescue OpenapiClient::ApiError => e
  puts "Error when calling PinsApi->pins_requestid_post: #{e}"
end
```

#### Using the pins_requestid_post_with_http_info variant

This returns an Array which contains the response data, status code and headers.

> <Array(<PinStatus>, Integer, Hash)> pins_requestid_post_with_http_info(requestid, pin)

```ruby
begin
  # Replace pin object
  data, status_code, headers = api_instance.pins_requestid_post_with_http_info(requestid, pin)
  p status_code # => 2xx
  p headers # => { ... }
  p data # => <PinStatus>
rescue OpenapiClient::ApiError => e
  puts "Error when calling PinsApi->pins_requestid_post_with_http_info: #{e}"
end
```

### Parameters

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **requestid** | **String** |  |  |
| **pin** | [**Pin**](Pin.md) |  |  |

### Return type

[**PinStatus**](PinStatus.md)

### Authorization

[accessToken](../README.md#accessToken)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

