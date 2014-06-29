#!/bin/bash

BASE_DIR='/data/dbpedia-release/data' #idem 'base-dir' in extraction.properties
TGT_WP='fr'
while getopts d:l: option; do
  case $option in
    d) BASE_DIR=$OPTARG;;
    l) TGT_WP=$OPTARG;;
    \?) echo "unsupported option $option";;
    :) "option $option requires an argument";;
  esac
done
echo "BASE_DIR: $BASE_DIR" 
echo "TGT_WP: ${TGT_WP}" 

./import_sameas_wikidata.sh -d ${BASE_DIR} -l ${TGT_WP}
./import_labels_wikidata.sh -d ${BASE_DIR} -l ${TGT_WP}
./import_abstracts_dbpedia.sh -d ${BASE_DIR} -l ${TGT_WP}



