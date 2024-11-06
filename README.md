
<!-- README.md is generated from README.Rmd. Please edit that file -->

# etnservice

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![Project Status: WIP – Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

The goal of etnservice is to to serve data from the European Tracking
Network as a restful API.

## About/Data Policy

Etn provides functionality to access data from the [European Tracking
Network (ETN)](http://www.lifewatch.be/etn/) database hosted by the
Flanders Marine Institute (VLIZ) as part of the Flemish contribution to
LifeWatch. ETN data is subject to the [ETN data
policy](http://www.lifewatch.be/etn/assets/docs/ETN-DataPolicy.pdf) and
can be:

  - restricted: under moratorium and only accessible to logged-in data
    owners/collaborators
  - unrestricted: publicly accessible without login and routinely
    published to international biodiversity facilities

The ETN infrastructure currently requires the package to be run within
the [LifeWatch.be RStudio server](http://rstudio.lifewatch.be/), which
is password protected. A login can be requested at
<http://www.lifewatch.be/etn/contact>.

## Installation

etnservice needs direct access to the [ETN](https://lifewatch.be/etn/)
database, thus a local install will not function without a copy of this
database.

You can install the development version of etnservice from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("inbo/etnservice")
```

## How to use the API

This is a basic example which shows you how adress the API directly:

``` r
library(httr) # to talk to the internet
library(magrittr) # to use pipes
library(jsonlite) # to work with JSON files
library(askpass) # to safly enter a password in R

# To access the ETN database, we need a login (username + password). We'll ask
# for the password dynamically because that's safer than storing it as an object
username <- "<your username here!>"
# All functions can be adressed directly in the URL
endpoint <- "https://opencpu.lifewatch.be/library/etn/R/list_animal_ids"
# Request the result of the function to be a json, and put in a request
response <-
    httr::POST(paste(endpoint, "json", sep = "/"),
      body = list(
        credentials = glue::glue('list(username = "{username}", password = "{askpass::askpass()}")')
      )
    )
# Take the response of the server, and convert it into an R object we can use
response %>%
    httr::content(as = "text", encoding = "UTF-8") %>%
    jsonlite::fromJSON(simplifyVector = TRUE)
```

However, a branch of the [etn package](https://github.com/inbo/etn) is
currently in development that will allow you to do this using built in
functions.

Another example of the same request as above, but now using
[curl](https://curl.se/):

``` bash
#! /bin/bash
curl --location --request POST 'https://opencpu.lifewatch.be/library/etnservice/R/list_animal_ids/json' \
--header 'Content-Type: application/json' \
--header 'Cookie: vliz_webc=vliz_webc2' \
--data-raw '{
    "credentials": {
        "username": "<your username>",
        "password": "<your password>"
    }
}'
```
