# OpenapiClient::PinsApi

All URIs are relative to *https://pinning-service.example.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**pins_get**](PinsApi.md#pins_get) | **GET** /pins | List pin objects
[**pins_post**](PinsApi.md#pins_post) | **POST** /pins | Add pin object
[**pins_requestid_delete**](PinsApi.md#pins_requestid_delete) | **DELETE** /pins/{requestid} | Remove pin object
[**pins_requestid_get**](PinsApi.md#pins_requestid_get) | **GET** /pins/{requestid} | Get pin object
[**pins_requestid_post**](PinsApi.md#pins_requestid_post) | **POST** /pins/{requestid} | Replace pin object



## pins_get

> PinResults pins_get(opts)

List pin objects

List all the pin objects, matching optional filters; when no filter is provided, only successful pins are returned

### Example

```ruby
# load the gem
require 'openapi_client'
# setup authorization
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

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cid** | [**Array&lt;String&gt;**](String.md)| Return pin objects responsible for pinning the specified CID(s); be aware that using longer hash functions introduces further constraints on the number of CIDs that will fit under the limit of 2000 characters per URL  in browser contexts | [optional] 
 **name** | **String**| Return pin objects with names that contain provided value (case-insensitive, partial or full match) | [optional] 
 **status** | [**Array&lt;Status&gt;**](Status.md)| Return pin objects for pins with the specified status | [optional] 
 **before** | **DateTime**| Return results created (queued) before provided timestamp | [optional] 
 **after** | **DateTime**| Return results created (queued) after provided timestamp | [optional] 
 **limit** | **Integer**| Max records to return | [optional] [default to 10]
 **meta** | [**Hash&lt;String, String&gt;**](String.md)| Return pin objects that match specified metadata | [optional] 

### Return type

[**PinResults**](PinResults.md)

### Authorization

[accessToken](../README.md#accessToken)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## pins_post

> PinStatus pins_post(pin)

Add pin object

Add a new pin object for the current access token

### Example

```ruby
# load the gem
require 'openapi_client'
# setup authorization
OpenapiClient.configure do |config|
  # Configure Bearer authorization: accessToken
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = OpenapiClient::PinsApi.new
pin = OpenapiClient::Pin.new # Pin | 

begin
  #Add pin object
  result = api_instance.pins_post(pin)
  p result
rescue OpenapiClient::ApiError => e
  puts "Exception when calling PinsApi->pins_post: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pin** | [**Pin**](Pin.md)|  | 

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

### Example

```ruby
# load the gem
require 'openapi_client'
# setup authorization
OpenapiClient.configure do |config|
  # Configure Bearer authorization: accessToken
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = OpenapiClient::PinsApi.new
requestid = 'requestid_example' # String | 

begin
  #Remove pin object
  api_instance.pins_requestid_delete(requestid)
rescue OpenapiClient::ApiError => e
  puts "Exception when calling PinsApi->pins_requestid_delete: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestid** | **String**|  | 

### Return type

nil (empty response body)

### Authorization

[accessToken](../README.md#accessToken)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## pins_requestid_get

> PinStatus pins_requestid_get(requestid)

Get pin object

Get a pin object and its status

### Example

```ruby
# load the gem
require 'openapi_client'
# setup authorization
OpenapiClient.configure do |config|
  # Configure Bearer authorization: accessToken
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = OpenapiClient::PinsApi.new
requestid = 'requestid_example' # String | 

begin
  #Get pin object
  result = api_instance.pins_requestid_get(requestid)
  p result
rescue OpenapiClient::ApiError => e
  puts "Exception when calling PinsApi->pins_requestid_get: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestid** | **String**|  | 

### Return type

[**PinStatus**](PinStatus.md)

### Authorization

[accessToken](../README.md#accessToken)

### HTTP request headers

- **Content-Type**: Not defined
- **Accept**: application/json


## pins_requestid_post

> PinStatus pins_requestid_post(requestid, pin)

Replace pin object

Replace an existing pin object (shortcut for executing remove and add operations in one step to avoid unnecessary garbage collection of blocks present in both recursive pins)

### Example

```ruby
# load the gem
require 'openapi_client'
# setup authorization
OpenapiClient.configure do |config|
  # Configure Bearer authorization: accessToken
  config.access_token = 'YOUR_BEARER_TOKEN'
end

api_instance = OpenapiClient::PinsApi.new
requestid = 'requestid_example' # String | 
pin = OpenapiClient::Pin.new # Pin | 

begin
  #Replace pin object
  result = api_instance.pins_requestid_post(requestid, pin)
  p result
rescue OpenapiClient::ApiError => e
  puts "Exception when calling PinsApi->pins_requestid_post: #{e}"
end
```

### Parameters


Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestid** | **String**|  | 
 **pin** | [**Pin**](Pin.md)|  | 

### Return type

[**PinStatus**](PinStatus.md)

### Authorization

[accessToken](../README.md#accessToken)

### HTTP request headers

- **Content-Type**: application/json
- **Accept**: application/json

