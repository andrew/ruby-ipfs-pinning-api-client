# OpenapiClient::PinStatus

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**requestid** | **String** | Globally unique identifier of the pin request; can be used to check the status of ongoing pinning, or pin removal | 
**status** | [**Status**](Status.md) |  | 
**created** | **DateTime** | Immutable timestamp indicating when a pin request entered a pinning service; can be used for filtering results and pagination | 
**pin** | [**Pin**](Pin.md) |  | 
**delegates** | **Array&lt;String&gt;** | List of multiaddrs designated by pinning service for transferring any new data from external peers | 
**info** | **Hash&lt;String, String&gt;** | Optional info for PinStatus response | [optional] 

## Code Sample

```ruby
require 'OpenapiClient'

instance = OpenapiClient::PinStatus.new(requestid: UniqueIdOfPinRequest,
                                 status: null,
                                 created: 2020-07-27T17:32:28Z,
                                 pin: null,
                                 delegates: [&quot;/dnsaddr/pin-service.example.com&quot;],
                                 info: {&quot;status_details&quot;:&quot;Queue position: 7 of 9&quot;})
```


