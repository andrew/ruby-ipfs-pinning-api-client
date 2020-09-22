=begin
#IPFS Pinning Service API

#  ## About this spec The IPFS Pinning Service API is intended to be an implementation-agnostic API&#x3a; - For use and implementation by pinning service providers - For use in client mode by IPFS nodes and GUI-based applications  > **Note**: while ready for implementation, this spec is still a work in progress! 🏗️  **Your input and feedback are welcome and valuable as we develop this API spec. Please join the design discussion at [github.com/ipfs/pinning-services-api-spec](https://github.com/ipfs/pinning-services-api-spec).**  # Schemas This section describes the most important object types and conventions.  A full list of fields and schemas can be found in the `schemas` section of the [YAML file](https://github.com/ipfs/pinning-services-api-spec/blob/master/ipfs-pinning-service.yaml).  ## Identifiers ### cid [Content Identifier (CID)](https://docs.ipfs.io/concepts/content-addressing/) points at the root of a DAG that is pinned recursively. ### requestid Unique identifier of a pin request.  When a pin is created, the service responds with unique `requestid` that can be later used for pin removal. When the same `cid` is pinned again, a different `requestid` is returned to differentiate between those pin requests.  Service implementation should use UUID, `hash(accessToken,Pin,PinStatus.created)`, or any other opaque identifier that provides equally strong protection against race conditions.  ## Objects ### Pin object  ![pin object](https://bafybeideck2fchyxna4wqwc2mo67yriokehw3yujboc5redjdaajrk2fjq.ipfs.dweb.link/pin.png)  The `Pin` object is a representation of a pin request.  It includes the `cid` of data to be pinned, as well as optional metadata in `name`, `origins`, and `meta`.  ### Pin status response  ![pin status response object](https://bafybeideck2fchyxna4wqwc2mo67yriokehw3yujboc5redjdaajrk2fjq.ipfs.dweb.link/pinstatus.png)  The `PinStatus` object is a representation of the current state of a pinning operation. It includes the original `pin` object, along with the current `status` and globally unique `requestid` of the entire pinning request, which can be used for future status checks and management. Addresses in the `delegates` array are peers delegated by the pinning service for facilitating direct file transfers (more details in the provider hints section). Any additional vendor-specific information is returned in optional `info`.  ## The pin lifecycle  ![pinning service objects and lifecycle](https://bafybeideck2fchyxna4wqwc2mo67yriokehw3yujboc5redjdaajrk2fjq.ipfs.dweb.link/lifecycle.png)  ### Creating a new pin object The user sends a `Pin` object to `POST /pins` and receives a `PinStatus` response: - `requestid` in `PinStatus` is the identifier of the pin operation, which can can be used for checking status, and removing the pin in the future - `status` in `PinStatus` indicates the current state of a pin  ### Checking status of in-progress pinning `status` (in `PinStatus`) may indicate a pending state (`queued` or `pinning`). This means the data behind `Pin.cid` was not found on the pinning service and is being fetched from the IPFS network at large, which may take time.  In this case, the user can periodically check pinning progress via `GET /pins/{requestid}` until pinning is successful, or the user decides to remove the pending pin.  ### Replacing an existing pin object The user can replace an existing pin object via `POST /pins/{requestid}`. This is a shortcut for removing a pin object identified by `requestid` and creating a new one in a single API call that protects against undesired garbage collection of blocks common to both pins. Useful when updating a pin representing a huge dataset where most of blocks did not change. The new pin object `requestid` is returned in the `PinStatus` response. The old pin object is deleted automatically.  ### Removing a pin object A pin object can be removed via `DELETE /pins/{requestid}`.   ## Provider hints Pinning of new data can be accelerated by providing a list of known data sources in `Pin.origins`, and connecting at least one of them to pinning service nodes at `PinStatus.delegates`.  The most common scenario is a client putting its own IPFS node's multiaddrs in `Pin.origins`,  and then directly connecting to every multiaddr returned by a pinning service in `PinStatus.delegates` to initiate transfer.  This ensures data transfer starts immediately (without waiting for provider discovery over DHT), and direct dial from a client works around peer routing issues in restrictive network topologies such as NATs.  ## Custom metadata Pinning services are encouraged to add support for additional features by leveraging the optional `Pin.meta` and `PinStatus.info` fields. While these attributes can be application- or vendor-specific, we encourage the community at large to leverage these attributes as a sandbox to come up with conventions that could become part of future revisions of this API. ### Pin metadata String keys and values passed in `Pin.meta` are persisted with the pin object.  Potential uses: - `Pin.meta[app_id]`: Attaching a unique identifier to pins created by an app enables filtering pins per app via `?meta={\"app_id\":<UUID>}` - `Pin.meta[vendor_policy]`: Vendor-specific policy (for example: which region to use, how many copies to keep)  Note that it is OK for a client to omit or ignore these optional attributes; doing so should not impact the basic pinning functionality.  ### Pin status info Additional `PinStatus.info` can be returned by pinning service.  Potential uses: - `PinStatus.info[status_details]`: more info about the current status (queue position, percentage of transferred data, summary of where data is stored, etc); when `PinStatus.status=failed`, it could provide a reason why a pin operation failed (e.g. lack of funds, DAG too big, etc.) - `PinStatus.info[dag_size]`: the size of pinned data, along with DAG overhead - `PinStatus.info[raw_size]`: the size of data without DAG overhead (eg. unixfs) - `PinStatus.info[pinned_until]`: if vendor supports time-bound pins, this could indicate when the pin will expire  # Pagination and filtering Pin objects can be listed by executing `GET /pins` with optional parameters:  - When no filters are provided, the endpoint will return a small batch of the 10 most recently created items, from the latest to the oldest. - The number of returned items can be adjusted with the `limit` parameter (implicit default is 10). - If the value in `PinResults.count` is bigger than the length of `PinResults.results`, the client can infer there are more results that can be queried. - To read more items, pass the `before` filter with the timestamp from `PinStatus.created` found in the oldest item in the current batch of results. Repeat to read all results. - Returned results can be fine-tuned by applying optional `after`, `cid`, `name`, `status`, or `meta` filters.  > **Note**: pagination by the `created` timestamp requires each value to be globally unique. Any future considerations to add support for bulk creation must account for this.  

The version of the OpenAPI document: 0.0.5

Generated by: https://openapi-generator.tech
OpenAPI Generator version: 4.3.1

=end

require 'cgi'

module OpenapiClient
  class PinsApi
    attr_accessor :api_client

    def initialize(api_client = ApiClient.default)
      @api_client = api_client
    end
    # List pin objects
    # List all the pin objects, matching optional filters; when no filter is provided, only successful pins are returned
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :cid Return pin objects responsible for pinning the specified CID(s); be aware that using longer hash functions introduces further constraints on the number of CIDs that will fit under the limit of 2000 characters per URL  in browser contexts
    # @option opts [String] :name Return pin objects with names that contain provided value (case-insensitive, partial or full match)
    # @option opts [Array<Status>] :status Return pin objects for pins with the specified status
    # @option opts [DateTime] :before Return results created (queued) before provided timestamp
    # @option opts [DateTime] :after Return results created (queued) after provided timestamp
    # @option opts [Integer] :limit Max records to return (default to 10)
    # @option opts [Hash<String, String>] :meta Return pin objects that match specified metadata
    # @return [PinResults]
    def pins_get(opts = {})
      data, _status_code, _headers = pins_get_with_http_info(opts)
      data
    end

    # List pin objects
    # List all the pin objects, matching optional filters; when no filter is provided, only successful pins are returned
    # @param [Hash] opts the optional parameters
    # @option opts [Array<String>] :cid Return pin objects responsible for pinning the specified CID(s); be aware that using longer hash functions introduces further constraints on the number of CIDs that will fit under the limit of 2000 characters per URL  in browser contexts
    # @option opts [String] :name Return pin objects with names that contain provided value (case-insensitive, partial or full match)
    # @option opts [Array<Status>] :status Return pin objects for pins with the specified status
    # @option opts [DateTime] :before Return results created (queued) before provided timestamp
    # @option opts [DateTime] :after Return results created (queued) after provided timestamp
    # @option opts [Integer] :limit Max records to return
    # @option opts [Hash<String, String>] :meta Return pin objects that match specified metadata
    # @return [Array<(PinResults, Integer, Hash)>] PinResults data, response status code and response headers
    def pins_get_with_http_info(opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PinsApi.pins_get ...'
      end
      if @api_client.config.client_side_validation && !opts[:'cid'].nil? && opts[:'cid'].length > 10
        fail ArgumentError, 'invalid value for "opts[:"cid"]" when calling PinsApi.pins_get, number of items must be less than or equal to 10.'
      end

      if @api_client.config.client_side_validation && !opts[:'cid'].nil? && opts[:'cid'].length < 1
        fail ArgumentError, 'invalid value for "opts[:"cid"]" when calling PinsApi.pins_get, number of items must be greater than or equal to 1.'
      end

      if @api_client.config.client_side_validation && !opts[:'name'].nil? && opts[:'name'].to_s.length > 255
        fail ArgumentError, 'invalid value for "opts[:"name"]" when calling PinsApi.pins_get, the character length must be smaller than or equal to 255.'
      end

      if @api_client.config.client_side_validation && !opts[:'status'].nil? && opts[:'status'].length < 1
        fail ArgumentError, 'invalid value for "opts[:"status"]" when calling PinsApi.pins_get, number of items must be greater than or equal to 1.'
      end

      if @api_client.config.client_side_validation && !opts[:'limit'].nil? && opts[:'limit'] > 1000
        fail ArgumentError, 'invalid value for "opts[:"limit"]" when calling PinsApi.pins_get, must be smaller than or equal to 1000.'
      end

      if @api_client.config.client_side_validation && !opts[:'limit'].nil? && opts[:'limit'] < 1
        fail ArgumentError, 'invalid value for "opts[:"limit"]" when calling PinsApi.pins_get, must be greater than or equal to 1.'
      end

      # resource path
      local_var_path = '/pins'

      # query parameters
      query_params = opts[:query_params] || {}
      query_params[:'cid'] = @api_client.build_collection_param(opts[:'cid'], :csv) if !opts[:'cid'].nil?
      query_params[:'name'] = opts[:'name'] if !opts[:'name'].nil?
      query_params[:'status'] = @api_client.build_collection_param(opts[:'status'], :csv) if !opts[:'status'].nil?
      query_params[:'before'] = opts[:'before'] if !opts[:'before'].nil?
      query_params[:'after'] = opts[:'after'] if !opts[:'after'].nil?
      query_params[:'limit'] = opts[:'limit'] if !opts[:'limit'].nil?
      query_params[:'meta'] = opts[:'meta'] if !opts[:'meta'].nil?

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      # return_type
      return_type = opts[:return_type] || 'PinResults' 

      # auth_names
      auth_names = opts[:auth_names] || ['accessToken']

      new_options = opts.merge(
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PinsApi#pins_get\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Add pin object
    # Add a new pin object for the current access token
    # @param pin [Pin] 
    # @param [Hash] opts the optional parameters
    # @return [PinStatus]
    def pins_post(pin, opts = {})
      data, _status_code, _headers = pins_post_with_http_info(pin, opts)
      data
    end

    # Add pin object
    # Add a new pin object for the current access token
    # @param pin [Pin] 
    # @param [Hash] opts the optional parameters
    # @return [Array<(PinStatus, Integer, Hash)>] PinStatus data, response status code and response headers
    def pins_post_with_http_info(pin, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PinsApi.pins_post ...'
      end
      # verify the required parameter 'pin' is set
      if @api_client.config.client_side_validation && pin.nil?
        fail ArgumentError, "Missing the required parameter 'pin' when calling PinsApi.pins_post"
      end
      # resource path
      local_var_path = '/pins'

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(pin) 

      # return_type
      return_type = opts[:return_type] || 'PinStatus' 

      # auth_names
      auth_names = opts[:auth_names] || ['accessToken']

      new_options = opts.merge(
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:POST, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PinsApi#pins_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Remove pin object
    # Remove a pin object
    # @param requestid [String] 
    # @param [Hash] opts the optional parameters
    # @return [nil]
    def pins_requestid_delete(requestid, opts = {})
      pins_requestid_delete_with_http_info(requestid, opts)
      nil
    end

    # Remove pin object
    # Remove a pin object
    # @param requestid [String] 
    # @param [Hash] opts the optional parameters
    # @return [Array<(nil, Integer, Hash)>] nil, response status code and response headers
    def pins_requestid_delete_with_http_info(requestid, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PinsApi.pins_requestid_delete ...'
      end
      # verify the required parameter 'requestid' is set
      if @api_client.config.client_side_validation && requestid.nil?
        fail ArgumentError, "Missing the required parameter 'requestid' when calling PinsApi.pins_requestid_delete"
      end
      # resource path
      local_var_path = '/pins/{requestid}'.sub('{' + 'requestid' + '}', CGI.escape(requestid.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      # return_type
      return_type = opts[:return_type] 

      # auth_names
      auth_names = opts[:auth_names] || ['accessToken']

      new_options = opts.merge(
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:DELETE, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PinsApi#pins_requestid_delete\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Get pin object
    # Get a pin object and its status
    # @param requestid [String] 
    # @param [Hash] opts the optional parameters
    # @return [PinStatus]
    def pins_requestid_get(requestid, opts = {})
      data, _status_code, _headers = pins_requestid_get_with_http_info(requestid, opts)
      data
    end

    # Get pin object
    # Get a pin object and its status
    # @param requestid [String] 
    # @param [Hash] opts the optional parameters
    # @return [Array<(PinStatus, Integer, Hash)>] PinStatus data, response status code and response headers
    def pins_requestid_get_with_http_info(requestid, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PinsApi.pins_requestid_get ...'
      end
      # verify the required parameter 'requestid' is set
      if @api_client.config.client_side_validation && requestid.nil?
        fail ArgumentError, "Missing the required parameter 'requestid' when calling PinsApi.pins_requestid_get"
      end
      # resource path
      local_var_path = '/pins/{requestid}'.sub('{' + 'requestid' + '}', CGI.escape(requestid.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] 

      # return_type
      return_type = opts[:return_type] || 'PinStatus' 

      # auth_names
      auth_names = opts[:auth_names] || ['accessToken']

      new_options = opts.merge(
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:GET, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PinsApi#pins_requestid_get\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end

    # Replace pin object
    # Replace an existing pin object (shortcut for executing remove and add operations in one step to avoid unnecessary garbage collection of blocks present in both recursive pins)
    # @param requestid [String] 
    # @param pin [Pin] 
    # @param [Hash] opts the optional parameters
    # @return [PinStatus]
    def pins_requestid_post(requestid, pin, opts = {})
      data, _status_code, _headers = pins_requestid_post_with_http_info(requestid, pin, opts)
      data
    end

    # Replace pin object
    # Replace an existing pin object (shortcut for executing remove and add operations in one step to avoid unnecessary garbage collection of blocks present in both recursive pins)
    # @param requestid [String] 
    # @param pin [Pin] 
    # @param [Hash] opts the optional parameters
    # @return [Array<(PinStatus, Integer, Hash)>] PinStatus data, response status code and response headers
    def pins_requestid_post_with_http_info(requestid, pin, opts = {})
      if @api_client.config.debugging
        @api_client.config.logger.debug 'Calling API: PinsApi.pins_requestid_post ...'
      end
      # verify the required parameter 'requestid' is set
      if @api_client.config.client_side_validation && requestid.nil?
        fail ArgumentError, "Missing the required parameter 'requestid' when calling PinsApi.pins_requestid_post"
      end
      # verify the required parameter 'pin' is set
      if @api_client.config.client_side_validation && pin.nil?
        fail ArgumentError, "Missing the required parameter 'pin' when calling PinsApi.pins_requestid_post"
      end
      # resource path
      local_var_path = '/pins/{requestid}'.sub('{' + 'requestid' + '}', CGI.escape(requestid.to_s))

      # query parameters
      query_params = opts[:query_params] || {}

      # header parameters
      header_params = opts[:header_params] || {}
      # HTTP header 'Accept' (if needed)
      header_params['Accept'] = @api_client.select_header_accept(['application/json'])
      # HTTP header 'Content-Type'
      header_params['Content-Type'] = @api_client.select_header_content_type(['application/json'])

      # form parameters
      form_params = opts[:form_params] || {}

      # http body (model)
      post_body = opts[:body] || @api_client.object_to_http_body(pin) 

      # return_type
      return_type = opts[:return_type] || 'PinStatus' 

      # auth_names
      auth_names = opts[:auth_names] || ['accessToken']

      new_options = opts.merge(
        :header_params => header_params,
        :query_params => query_params,
        :form_params => form_params,
        :body => post_body,
        :auth_names => auth_names,
        :return_type => return_type
      )

      data, status_code, headers = @api_client.call_api(:POST, local_var_path, new_options)
      if @api_client.config.debugging
        @api_client.config.logger.debug "API called: PinsApi#pins_requestid_post\nData: #{data.inspect}\nStatus code: #{status_code}\nHeaders: #{headers}"
      end
      return data, status_code, headers
    end
  end
end
