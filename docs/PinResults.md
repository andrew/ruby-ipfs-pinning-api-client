# OpenapiClient::PinResults

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**count** | **Integer** | The total number of pin objects that exist for passed query filters | 
**results** | [**Array&lt;PinStatus&gt;**](PinStatus.md) | An array of PinStatus results | 

## Code Sample

```ruby
require 'OpenapiClient'

instance = OpenapiClient::PinResults.new(count: 1,
                                 results: null)
```


