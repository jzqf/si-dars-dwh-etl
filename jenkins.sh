#!/bin/sh
cd dars-dwh-etl/
mvn -e -V -B -U clean deploy -P jenkins
