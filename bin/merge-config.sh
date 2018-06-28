#!/bin/bash

# Include environment variables
source ${app.rootDir}/${app.user}/bin/${app.name}-env.sh

# Run combiner app
java -jar ${app.rootDir}/${app.user}/lib/merge_configuration_files.jar
