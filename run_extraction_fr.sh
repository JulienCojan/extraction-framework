#!/bin/bash

INITIAL_PATH=$(realpath ${0%/*})
cd dump

../run download "config=download.properties"

../run extraction "extraction.wikipedia-fr.properties"
../run extraction "extraction.wikidata.properties"

cd src/main/bash/
./import_external_data.sh

cd ${INITIAL_PATH}

