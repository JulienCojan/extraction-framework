#!/bin/bash

BASE_DIR='/data/dbpedia-release/data' #idem 'base-dir' in extraction.properties
LANG='fr'

INITIAL_PATH=$(realpath ${0%/*})

## download ontology + mappings
cd core
../run download-ontology
../run download-mappings
cd ${INITIAL_PATH}

## run the extraction
cd dump
../run download "config=download.properties"
../run import
../run extraction "extraction.wikipedia-fr.properties"
../run extraction "extraction.wikidata.properties"

cd src/main/bash/
./import_external_data.sh -d ${BASE_DIR} -l ${LANG}

cd ${INITIAL_PATH}

