# Connect to the ETN database

Connect to the ETN database using username and password.

## Usage

``` r
connect_to_etn(username, password)
```

## Arguments

- username:

  Character. Username to use for the connection.

- password:

  Character. Password to use for the connection.

## Value

ODBC connection to ETN database.

## Examples

``` r
if (FALSE) { # \dontrun{
# Connect to the ETN database using your rstudio.lifewatch.be username and
# password, and save as the default connection variable "con"
con <- connect_to_etn()

# Connect to the ETN database using non-default username and password
con <- connect_to_etn(username = "my_username", password = "my_password")
} # }
```
