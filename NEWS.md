# etnservice 0.1.2

- Updated integration tests (JavaScript) for postman monitor (#62).
- Fixed broken example in README and updated it to use `httr2` (#64).

# etnservice 0.1.1

- Added badges to the README.
- Improvements to CI, note that tests and examples are not checked on github. These still need to be checked on a machine that has access to the ETN database.

# etnservice v0.1.0

- This is the first version of etnservice used in the beta of etn v2.3.0.
- This version is still lagging behind it's contemporary version of etn v2.2.1, which means that database queries made via etnservice, or via the OpenCPU API are not guaranteed to be identical as the results of the same queries made via the etn R package.
