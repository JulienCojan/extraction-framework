#!/bin/bash

BASE_DIR='/data/dbpedia-release/data'
LANG='fr'

INITIAL_PATH=$(realpath ${0%/*})
cd dump

../run download "config=download.properties"

../run extraction "extraction.wikipedia-fr.properties"
../run extraction "extraction.wikidata.properties"

cd src/main/bash/
./import_external_data.sh -d ${BASE_DIR} -l ${LANG}

cd ${INITIAL_PATH}

