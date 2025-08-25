# etnservice 0.4.0
- Added `get_version()` which allows users to easily compare their locally installed version of `etnservice` with the one deployed on the OpenCPU API. (#81)
- Added `get_acoustic_detections_page()` which fetches a single page from the new detections view. This function allows paginated access and is to be called by the etn package function `get_acoustic_detections()` to make fetching large numbers of detections more efficient. (#85)
- The `depth_in_meters` field is not returned as part of `get_acoustic_detections_page()`, this was a calculated field that has proved unreliable. It was also causing performance issues in the database. As an alternative depth can (sometimes) be retreived via `sensor_value` and `sensor_unit`, which will be more dependable than a calculation based on slope.

# etnservice 0.3.0

- Added `depth_in_meters` field to `get_acoustic_detections()` to achieve feature parity with the etn package (#72, [inbo/etn#274](https://github.com/inbo/etn/pull/274)).

# etnservice 0.2.0

- Add new function `validate_login()` to check if the provided credentials grant access to ETN (#59).
- Fixed bug in `write_dwc()` where providing no value for `rights_holder` would result in the function failing to output a data.frame (#69).
- etnservice will now no longer return duplicate receiver_ids in `list_receiver_ids()` ([inbo/etn#333](https://github.com/inbo/etn/issues/333).

# etnservice 0.1.2

- Updated integration tests (JavaScript) for postman monitor (#62).
- Fixed broken example in README and updated it to use `httr2` (#64).

# etnservice 0.1.1

- Added badges to the README.
- Improvements to CI, note that tests and examples are not checked on github. These still need to be checked on a machine that has access to the ETN database.

# etnservice v0.1.0

- This is the first version of etnservice used in the beta of etn v2.3.0.
- This version is still lagging behind its contemporary version of etn v2.2.1, which means that database queries made via etnservice, or via the OpenCPU API are not guaranteed to be identical as the results of the same queries made via the etn R package.
