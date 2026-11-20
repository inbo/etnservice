# Version information about etnservice

Users of the etn package might (probably will) have a local version of
etnservice. If there are differences between the version deployed on the
API and the version installed locally, this might lead to inconsistent
results when switching between local database queries and queries over
the API. This function returns version information of the installed
version of etnservice, when called over the api, it'll return version
information on the version of etnservice deployed via opencpu.

## Usage

``` r
get_version()
```

## Value

A list with the following elements:

- ls:

  A character vector of the objects in the environment.

- version:

  The version of the etnservice package.

## Examples

``` r
get_version()
#> $fn_checksums
#> $fn_checksums$check_connection
#> [1] "5c5242691df9c5eb2aa1ec68e73a66e8"
#> 
#> $fn_checksums$check_credentials
#> [1] "a23ad58612dc39f09f3c2bbd9ac942c2"
#> 
#> $fn_checksums$check_date_time
#> [1] "b98be30e71c5184449d9de88d143792c"
#> 
#> $fn_checksums$check_value
#> [1] "f32ce25ad512a36ff95e96d51afb59e6"
#> 
#> $fn_checksums$connect_to_etn
#> [1] "563a5c8c8199c890cb69976480e92bd9"
#> 
#> $fn_checksums$extract_temp_key
#> [1] "038b8ee90d1c0ee07be838cd0b4f32a0"
#> 
#> $fn_checksums$get_acoustic_deployment_logs
#> [1] "32836bcf9f790f51a28bc341e4082116"
#> 
#> $fn_checksums$get_acoustic_deployments
#> [1] "ae068e48247d1d6523397a443cef5d6e"
#> 
#> $fn_checksums$get_acoustic_detections
#> [1] "2e74d82ab1b8630b7acddf59c1420d0b"
#> 
#> $fn_checksums$get_acoustic_detections_page
#> [1] "9025d39b15acd587a7c45dd877d1e607"
#> 
#> $fn_checksums$get_acoustic_projects
#> [1] "2f16f6db52120168f69d5669e745bd1f"
#> 
#> $fn_checksums$get_acoustic_receivers
#> [1] "bb33147533b3e7fe48fa10a1da12e0dc"
#> 
#> $fn_checksums$get_animal_projects
#> [1] "27e98dad575e5bfbd66a8e2b194320de"
#> 
#> $fn_checksums$get_animals
#> [1] "5134ba849050903a0d82978dde18915c"
#> 
#> $fn_checksums$get_archival_data_uuid
#> [1] "7dc3753b43eb5a0412413086d2fb5764"
#> 
#> $fn_checksums$get_cpod_projects
#> [1] "893d9b41ae9990684ead60257a48a6d5"
#> 
#> $fn_checksums$get_credentials
#> [1] "d364b895ab16f03535218c5681a821c2"
#> 
#> $fn_checksums$get_tags
#> [1] "d99619d9c4ad5be47f8e08672599555f"
#> 
#> $fn_checksums$get_val
#> [1] "d9ebee2ad1a58db16272337be7d2f29d"
#> 
#> $fn_checksums$get_version
#> [1] "a05a33c40a35a1f8ccac458c90371165"
#> 
#> $fn_checksums$list_acoustic_project_codes
#> [1] "549f1a9f18b1efb9d6c50cc46b0bdb42"
#> 
#> $fn_checksums$list_acoustic_tag_ids
#> [1] "98e5af3e72f5ae924a99b945084f4858"
#> 
#> $fn_checksums$list_animal_ids
#> [1] "463783012ee23e6fe8bbdde06e3f1361"
#> 
#> $fn_checksums$list_animal_project_codes
#> [1] "e5d0b2d8e74553816d41261c50257491"
#> 
#> $fn_checksums$list_cpod_project_codes
#> [1] "ca2badf6a650620462f4ae5f0f666137"
#> 
#> $fn_checksums$list_deployment_ids
#> [1] "ef1821c6c4912573746fc81d12e38030"
#> 
#> $fn_checksums$list_receiver_ids
#> [1] "eca74641cbcfe4e8214f53ff861f9ebe"
#> 
#> $fn_checksums$list_scientific_names
#> [1] "d8254960052a6dbeba9986af944d5a39"
#> 
#> $fn_checksums$list_station_names
#> [1] "6a1e2736d13643889576aa773b99c46e"
#> 
#> $fn_checksums$list_tag_serial_numbers
#> [1] "c41c2c11eadf5a3e02cb77a89ea57d90"
#> 
#> $fn_checksums$validate_login
#> [1] "372be31e067d95ce50c49762fd48d853"
#> 
#> 
#> $version
#> [1] ‘0.7.2.9000’
#> 
```
