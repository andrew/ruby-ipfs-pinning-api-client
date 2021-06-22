# OpenapiClient::Pin

## Properties

| Name | Type | Description | Notes |
| ---- | ---- | ----------- | ----- |
| **cid** | **String** | Content Identifier (CID) to be pinned recursively |  |
| **name** | **String** | Optional name for pinned data; can be used for lookups later | [optional] |
| **origins** | **Array&lt;String&gt;** | Optional list of multiaddrs known to provide the data | [optional] |
| **meta** | **Hash&lt;String, String&gt;** | Optional metadata for pin object | [optional] |

## Example

```ruby
require 'openapi_client'

instance = OpenapiClient::Pin.new(
  cid: QmCIDToBePinned,
  name: PreciousData.pdf,
  origins: [&quot;/ip4/203.0.113.142/tcp/4001/p2p/QmSourcePeerId&quot;,&quot;/ip4/203.0.113.114/udp/4001/quic/p2p/QmSourcePeerId&quot;],
  meta: {&quot;app_id&quot;:&quot;99986338-1113-4706-8302-4420da6158aa&quot;}
)
```

