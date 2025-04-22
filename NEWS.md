# etnservice 0.2.0

- Add new function `validate_login()` to check if the provided credentials grant access to ETN (#59).
- Fixed bug in `write_dwc()` where providing no value for `rights_holder` would result in the function failing to output a data.frame (#69)
- etnservice will now no longer return duplicate receiver_ids in `list_receiver_ids()`: inbo/etn#333

# etnservice 0.1.2

- Updated integration tests (JavaScript) for postman monitor (#62).
- Fixed broken example in README and updated it to use `httr2` (#64).

# etnservice 0.1.1

- Added badges to the README.
- Improvements to CI, note that tests and examples are not checked on github. These still need to be checked on a machine that has access to the ETN database.

# etnservice v0.1.0

- This is the first version of etnservice used in the beta of etn v2.3.0.
- This version is still lagging behind its contemporary version of etn v2.2.1, which means that database queries made via etnservice, or via the OpenCPU API are not guaranteed to be identical as the results of the same queries made via the etn R package.
