# marine-recorder-tools
Marine Recorder Tools 

This repository is for tools developed to work with Marine Recorder.

## Marine Recorder Information, Application and Public Snapshot (Data)

* [Marine Recorder Information and Snapshot](http://jncc.defra.gov.uk/page-1599)
* [Marine Recorder Application](https://www.esdm.co.uk/marine-recorder)

## What is Marine Recorder
Marine Recorder  is the leading database software used by JNCC partner organisations for storing, managing and querying marine benthic sample data such as species, physical attributes and biotopes. It is fullycompatible with the NBN data model, enabling data to be contributed to the NBN Atlas.

It was originally developed to be the marine equivalent of Recorder, but accommodates a much wider range of data, including:
* surveys and samples;
* species;
* habitats and biotopes;
* environmental variables, such as salinity and temperature;
* physical variables, such as substrate, depth, inclination, sediment type.

In addition, there is also additional modules and tools that assists users in filtering, reporting, querying, disseminating and merging data with other Marine Recorder datasets. These include:
* MarineSnapshotv515: takes a NBN data file and creates a useable snapshot database, often used for the majority of work areas (e.g. Habitat Mapping, Assessment etc.).
* SnapshotMergev511: allows users to merge together separate snapshot datasets.
* MarineMergev5: allows users to merge together separate NBN data files.
* Marine Recorder reporting wizard: provides a user interface to allow simpler data querying, also comes with a link to directly map queried data straight into ArcGIS.
* MarRecorderTOGateway_v194: converts all Marine Recorder snapshot data into a NBN-compatible text file, output can be submitted via the NBN Atlas.


## marineRecorder R Package

A Marine Recorder R Package was developed to work with the snapshot. The R package contains functions to work with the snapshot by creating shapefiles, checking for new surveys and checking the species in the species dictionary (a separate database used with the main application).

### Installation of 'marineRecorder' R Package

install.packages("devtools")

devtools::install_github("jncc/marine-recorder-tools/marineRecorder")

