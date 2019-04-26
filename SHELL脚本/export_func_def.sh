#!/bin/bash
##export all function which of one schema for postgresql
DBNAME=$5
SCHEMA=$6
HOST=$1
PORT=$2
USER=$3
PASS=$4

if [ $# -ne 6 ];then
        echo "./export_func_def.sh host port user password database schema"
        exit 0
fi

export PGPASSWORD=$PASS

CUR_DIR=`pwd`
OUT_DIR=$CUR_DIR/out_func_def
mkdir -p $OUT_DIR
if [ ! -d $OUT_DIR ];then
        echo "mkdir -p $OUT_DIR failed,exit"
        exit -1
fi

for i in `psql -h $HOST -p $PORT -U $USER -d $DBNAME -At -c "select pro.oid,pro.proname from pg_proc pro,pg_namespace nsp where proisagg='f' and nsp.oid=pro.pronamespace and nsp.nspname='$SCHEMA' ;"`
do
        functionid=`echo $i|awk -F '|' '{print $1}'`
        filename=`echo $i|awk -F '|' '{print $2}'`
        psql -h $HOST -p $PORT -U $USER -d $DBNAME -At -c "select pg_get_functiondef($functionid) ;" >$OUT_DIR/$filename.sql
done
