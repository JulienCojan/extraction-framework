#!/bin/bash

export LC_ALL=C

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

WD_DATE=$(ls -d ${BASE_DIR}/wikidatawiki/* | grep -o "[0-9]\{8\}$" | sort -r | head -n 1)
WP_DATE=$(ls -d ${BASE_DIR}/${TGT_WP}wiki/* | grep -o "[0-9]\{8\}$" | sort -r | head -n 1)

PREFIX_WD="${BASE_DIR}/wikidatawiki/${WD_DATE}/wikidatawiki-${WD_DATE}-wikidata"
OUTPUT_DIR="${BASE_DIR}/${TGT_WP}wiki/${WP_DATE}"
PREFIX_OUT="${OUTPUT_DIR}/wikidatawiki-${WD_DATE}-wikidata"

###
# Extract labels from wikidata and join with TGT_WP.dbpedia
###

WIKIDATA_SAMEAS_TGT="${PREFIX_OUT}-sameas-${TGT_WP}.ttl.gz"
WIKIDATA_LABELS="${PREFIX_WD}-labels.ttl.gz"
LABELS_TGT="${PREFIX_OUT}-labels-${TGT_WP}.ttl.gz"

echo "extract labels from wikidata into :"
echo "  ${LABELS_TGT}"
join -13 -21 <(zcat ${WIKIDATA_SAMEAS_TGT}) <(zcat ${WIKIDATA_LABELS} | sort -k 1) | \
  sed 's/<[^>]*> \(<[^>]*>\) <[^>]*> \./\1/' | gzip > ${LABELS_TGT}

