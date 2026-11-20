# Transform ETN data to Darwin Core

Transforms and downloads data from a European Tracking Network **animal
project** to [Darwin Core](https://dwc.tdwg.org/). The resulting
dataframe can be saved as a CSV and be uploaded to an
[IPT](https://www.gbif.org/ipt) for publication to OBIS and/or GBIF. A
`meta.xml` or `eml.xml` file are not created.

## Usage

``` r
write_dwc(
  credentials = list(username = Sys.getenv("ETN_USER"), password = Sys.getenv("ETN_PWD")),
  animal_project_code,
  rights_holder = NULL,
  license = "CC-BY"
)
```

## Arguments

- credentials:

  A list with the username and password to connect to the ETN database.

- animal_project_code:

  Animal project code.

- rights_holder:

  Acronym of the organization owning or managing the rights over the
  data.

- license:

  Identifier of the license under which the data will be published.

  - [`CC-BY`](https://creativecommons.org/licenses/by/4.0/legalcode)
    (default).

  - [`CC0`](https://creativecommons.org/publicdomain/zero/1.0/legalcode).

## Value

list of dataframes

## Transformation details

Data are transformed into an [Occurrence
core](https://rs.gbif.org/core/dwc_occurrence_2022-02-02.xml). This
**follows recommendations** discussed and created by Peter Desmet, Jonas
Mortelmans, Jonathan Pye, John Wieczorek and others. See the [SQL
file(s)](https://github.com/inbo/etnservice/tree/main/inst/sql) used by
this function for details.

Key features of the Darwin Core transformation:

- Deployments (animal+tag associations) are parent events, with capture,
  surgery, release, recapture (human observations) and acoustic
  detections (machine observations) as child events. No information
  about the parent event is provided other than its ID, meaning that
  data can be expressed in an Occurrence Core with one row per
  observation and `parentEventID` shared by all occurrences in a
  deployment.

- The release event often contains metadata about the animal (sex,
  lifestage, comments) and deployment as a whole.

- Acoustic detections are downsampled to the **first detection per
  hour**, to reduce the size of high-frequency data. Duplicate
  detections (same animal, tag and timestamp) are excluded. It is
  possible for a deployment to contain no detections, e.g. if the tag
  malfunctioned right after deployment.
