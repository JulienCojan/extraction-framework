#!/bin/bash

export LC_ALL=C

TGT_WP='fr'
BASE_DIR='/data/dbpedia-release/data' #idem 'base-dir' in extraction.properties

WD_DATE=$(ls -d ${BASE_DIR}/wikidatawiki/* | grep -o "[0-9]\{8\}$" | sort -r | head -n 1)
WP_DATE=$(ls -d ${BASE_DIR}/${TGT_WP}wiki/* | grep -o "[0-9]\{8\}$" | sort -r | head -n 1)

PREFIX_WD="${BASE_DIR}/wikidatawiki/${WD_DATE}/wikidatawiki-${WD_DATE}-wikidata"
OUTPUT_DIR="${BASE_DIR}/${TGT_WP}wiki/${WP_DATE}"
PREFIX_OUT="${OUTPUT_DIR}/wikidatawiki-${WD_DATE}-wikidata"

###
# Extract owl:sameAs links for TGT_WP as subject
###

WIKIDATA_LL="${PREFIX_WD}-ll.ttl.gz"
LL_TGT="${PREFIX_OUT}-ll-${TGT_WP}.ttl.gz"

echo "export interlanguage links for ${TGT_WP} from wikidata into :"
echo "  $LL_TGT"

zcat ${WIKIDATA_LL} |  grep -v "^#" | \
  awk '$1~"^<http://'${TGT_WP}'\\." {print $0}' | gzip > ${LL_TGT}


###
# Extract owl:sameAs links between wikidata and TGT_WP.dbpedia
###

WIKIDATA_SAMEAS="${PREFIX_WD}-sameas.ttl.gz"
WIKIDATA_SAMEAS_TGT="${PREFIX_OUT}-sameas-${TGT_WP}.ttl.gz"

echo "export owl:sameAs links between wikidata and ${TGT_WP} wikipedia into :"
echo "  ${WIKIDATA_SAMEAS_TGT}"

zcat ${WIKIDATA_SAMEAS} |  grep -v "^#" | \
  awk '$3~"^<http://'${TGT_WP}'\\." {print $3 " " $2 " " $1 " ."}' | \
  sort -k 3 | gzip > ${WIKIDATA_SAMEAS_TGT}

