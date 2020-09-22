# OpenapiClient::ErrorError

## Properties

Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**reason** | **String** | Mandatory string identifying the type of error | 
**details** | **String** | Optional, longer description of the error; may include UUID of transaction for support, links to documentation etc | [optional] 

## Code Sample

```ruby
require 'OpenapiClient'

instance = OpenapiClient::ErrorError.new(reason: ERROR_CODE_FOR_MACHINES,
                                 details: Optional explanation for humans with more details)
```


