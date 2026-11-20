# Check ETN Database Credentials

Validates user credentials for the ETN database by attempting to
establish a connection. Returns `TRUE` if the credentials are valid and
`FALSE` otherwise.

## Usage

``` r
validate_login(username, password)
```

## Arguments

- username:

  Character string containing the ETN database username.

- password:

  Character string containing the ETN database password.

## Value

Logical `TRUE` if credentials are valid and the connection is
successful, `FALSE` if authentication fails.

## Examples

``` r
# Check if credentials are valid
 validate_login("invalid_username", "invalid_password")
#> [1] FALSE
```
