#!/bin/bash

export LC_ALL=C

TGT_WP='fr'
BASE_DIR='/data/dbpedia-release/data' #idem 'base-dir' in extraction.properties

# lang codes from which will be imported abstracts and labels
IMPORT_FROM=('ca' 'de' 'en' 'es' 'eu' 'it' 'ja' 'oc' 'pt' 'ru' 'zh')

WD_DATE=$(ls -d ${BASE_DIR}/wikidatawiki/* | grep -o "[0-9]\{8\}$" | sort -r | head -n 1)
WP_DATE=$(ls -d ${BASE_DIR}/${TGT_WP}wiki/* | grep -o "[0-9]\{8\}$" | sort -r | head -n 1)

OUTPUT_DIR="${BASE_DIR}/${TGT_WP}wiki/${WP_DATE}"
PREFIX_OUT="${OUTPUT_DIR}/wikidatawiki-${WD_DATE}-wikidata"


###
# Importing abstracts
###
for LANG in "${IMPORT_FROM[@]}"; do
    echo "importing abstracts from $LANG"
    DBPEDIA_PREFIX=$LANG
    if [ $LANG == "en" ]; then
      DBPEDIA_PREFIX='dbpedia'
    fi

    LL_TGT="${PREFIX_OUT}-ll-${TGT_WP}.ttl.gz"
    TMP_LL="${PREFIX_OUT}-ll-${TGT_WP}-${LANG}.ttl"
    zcat ${LL_TGT} | awk '$3~"^<http://'${DBPEDIA_PREFIX}'\\." {print $0}' | \
      sort -k 3 -T "/home/jcojan/SharedFolder/tmp/" > ${TMP_LL}

    for ABS in "short_abstracts" "long_abstracts"; do
      ABS_FILE_NAME="${ABS}_${LANG}.ttl.bz2"
      ABS_URL="http://downloads.dbpedia.org/current/${LANG}/${ABS_FILE_NAME}"
      ABS_FILE=${OUTPUT_DIR}/${ABS_FILE_NAME}
      OUT_ABS=${OUTPUT_DIR}/"${ABS}_"${LANG}"_for_${TGT_WP}.ttl.gz"

      if [[ ! -s ${ABS_FILE} ]]
      then
        wget ${ABS_URL} -O ${ABS_FILE}
      fi
      join -13 -21 ${TMP_LL} <(bzcat ${ABS_FILE}| sort -k 1 -T "/home/jcojan/SharedFolder/tmp/" ) | \
      sed 's/<[^>]*> \(<[^>]*>\) <[^>]*> \./\1/' | gzip > ${OUT_ABS}

      echo "  ${OUT_ABS}"

      rm $ABS_FILE
    done #ABS

    rm $TMP_LL
done #LANG
